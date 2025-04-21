import 'package:blackox/CropCalculator/bom_screen.dart';
import 'package:blackox/Services/database_services.dart';
import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CropCalculator extends StatefulWidget {
  const CropCalculator({super.key});

  @override
  State<CropCalculator> createState() => _CropCalculatorState();
}

class _CropCalculatorState extends State<CropCalculator> {
  //String? _selectedMonth;
  String? _selectedSoilType;
  String? _selectedCropCategory;
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedTaluka;
  double _sowingArea = 0;
  Country? _selectedCountryCurrency;
  String? _selectedUnitOfMeasurement;
  DatabaseService dbService = DatabaseService();

  final List<String> _selectedCrops = [];
  List<String> soilType = [];
  List<String> cropCategories = [];
  List<String> crops = [];
  List<Map<String, dynamic>> cropData = [];
  List<String> countries = [];
  List<String> states = [];
  List<String> districts = [];
  List<String> talukas = [];
  List<String> unitsOfMeasurement = ['Acre', 'Hectare', 'Square Meter'];

  @override
  void initState() {
    super.initState();
    //_selectedMonth = DateFormat('MMMM').format(DateTime.now());
    _fetchCountries();
  }

  // Fetch Country Data
  void _fetchCountries() async {
    try {
      countries = await dbService.fetchCountries();
      setState(() {
        _selectedCountry = null; // Reset selections
        _selectedState = null;
        _selectedDistrict = null;
        _selectedTaluka = null;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load countries: $error')),
      );
    }
  }

  // Fetch State Data
  void _fetchStates(String country) async {
    try {
      states = await dbService.fetchStates(country);
      setState(() {
        _selectedState = null;
        _selectedDistrict = null;
        _selectedTaluka = null;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load states: $error')),
      );
    }
  }

  // Fetch District Data
  void _fetchDistricts(String state) async {
    try {
      districts = await dbService.fetchDistricts(state);
      setState(() {
        _selectedDistrict = null;
        _selectedTaluka = null;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load districts: $error')),
      );
    }
  }

  // Fetch Taluka Data
  void _fetchTalukas(String district) async {
    try {
      talukas = await dbService.fetchTalukas(district);
      setState(() {
        _selectedTaluka = null;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load talukas: $error')),
      );
    }
  }

  // Fetch Soil Types based on country, state, district, and taluka
  void _fetchSoilTypes() async {
    try {
      if (_selectedCountry != null &&
          _selectedState != null &&
          _selectedDistrict != null &&
          _selectedTaluka != null) {
        List<String> soilTypes = await dbService.fetchSoilTypes(
            country: _selectedCountry!,
            state: _selectedState!,
            district: _selectedDistrict!,
            taluka: _selectedTaluka!);

        setState(() {
          soilType = soilTypes;
          _selectedSoilType = null;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load soil types: $error')),
      );
    }
  }

  void _fetchCropCategories(String soilType) async {
    if (_selectedCountry == null ||
        _selectedState == null ||
        _selectedDistrict == null ||
        _selectedTaluka == null) {
      return; // Ensure all location fields are selected
    }

    // Perform the fetch with location parameters
    final categories = await dbService.fetchCropCategories(
      country: _selectedCountry!,
      state: _selectedState!,
      district: _selectedDistrict!,
      taluka: _selectedTaluka!,
      soilType: soilType,
    );

    setState(() {
      cropCategories = categories;
      _selectedCropCategory =
          null; // Reset the crop category when soil type changes
    });
  }

  void _fetchCrops(String cropCategory, String soilType) async {
    if (_selectedCountry == null ||
        _selectedState == null ||
        _selectedDistrict == null ||
        _selectedTaluka == null) {
      return; // Ensure all location fields are selected
    }

    // Perform the fetch with location parameters
    cropData = await dbService.fetchCrops(
      country: _selectedCountry!,
      state: _selectedState!,
      district: _selectedDistrict!,
      taluka: _selectedTaluka!,
      soilType: soilType,
      cropCategory: cropCategory,
    );
    List<String> cropList =
        cropData.map((data) => data['cropcultivated'] as String).toList();

    setState(() {
      crops = cropList;
    });
  }

  void _onSubmit() async {
    if (_selectedCrops.isNotEmpty && _sowingArea > 0) {
      try {
        List<Map<String, String>> bomDataList = [];

        for (String crop in _selectedCrops) {
          // Find the crop data for the selected crop
          var selectedCropData =
              cropData.firstWhere((data) => data['cropcultivated'] == crop);
          String soilCode = selectedCropData['soilcode'];

          // Fetch bomid and bomcode using the selected soilcode
          var bomData = await dbService.fetchBOMBySoilCode(soilCode);

          bomDataList.add({
            'bomId': bomData['bomid'].toString(),
            'bomCode': bomData['bomcode'],
            'crop': bomData['crop']
          });
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BOMScreen(
              bomData: bomDataList,
              name: _selectedCrops.join(', '),
              sowingArea: _sowingArea,
              unitOfMeasure: _selectedUnitOfMeasurement!,
            ),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to fetch BOM details: $error'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Calculator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Crop Calculator',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  backgroundColor: Colors.yellowAccent,
                ),
              ),
              const SizedBox(height: 16),

              // Country and State Dropdown in Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Country*', style: TextStyle(fontSize: 16)),
                        DropdownButton<String>(
                          value: _selectedCountry,
                          hint: const Text('Select Country'),
                          isExpanded: true,
                          items: countries.map((String country) {
                            return DropdownMenuItem<String>(
                              value: country,
                              child: Text(country),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCountry = newValue;
                              if (newValue != null) {
                                _fetchStates(
                                    newValue); // Fetch states based on country
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16), // Spacer between dropdowns
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('State*', style: TextStyle(fontSize: 16)),
                        DropdownButton<String>(
                          value: _selectedState,
                          hint: const Text('Select State'),
                          isExpanded: true,
                          items: states.map((String state) {
                            return DropdownMenuItem<String>(
                              value: state,
                              child: Text(state),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedState = newValue;
                              if (newValue != null) {
                                _fetchDistricts(
                                    newValue); // Fetch districts based on state
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // District and Taluka Dropdowns
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('District*', style: TextStyle(fontSize: 16)),
                        DropdownButton<String>(
                          value: _selectedDistrict,
                          hint: const Text('Select District'),
                          isExpanded: true,
                          items: districts.map((String district) {
                            return DropdownMenuItem<String>(
                              value: district,
                              child: Text(district),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedDistrict = newValue;
                              if (newValue != null) {
                                _fetchTalukas(
                                    newValue); // Fetch talukas based on district
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Taluka*', style: TextStyle(fontSize: 16)),
                        DropdownButton<String>(
                          value: _selectedTaluka,
                          hint: const Text('Select Taluka'),
                          isExpanded: true,
                          items: talukas.map((String taluka) {
                            return DropdownMenuItem<String>(
                              value: taluka,
                              child: Text(taluka),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedTaluka = newValue;
                              if (newValue != null) {
                                _fetchSoilTypes(); // Fetch soil types after taluka is selected
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Soil Type Dropdown
              const Text('Soil Type*', style: TextStyle(fontSize: 16)),
              DropdownButton<String>(
                value: _selectedSoilType,
                hint: const Text('Select Soil Type'),
                isExpanded: true,
                items: soilType.map((String soilType) {
                  return DropdownMenuItem<String>(
                    value: soilType,
                    child: Text(soilType),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSoilType = newValue;
                    if (newValue != null) {
                      _fetchCropCategories(
                          newValue); // Fetch crop categories by soil type
                    }
                  });
                },
              ),

              const SizedBox(height: 16),

              // Crop Category Dropdown
              const Text('Crop Category*', style: TextStyle(fontSize: 16)),
              DropdownButton<String>(
                value: _selectedCropCategory,
                hint: const Text('Select Crop Category'),
                isExpanded: true,
                items: cropCategories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCropCategory = newValue;
                    if (newValue != null && _selectedSoilType != null) {
                      _fetchCrops(newValue, _selectedSoilType!); // Fetch crops
                    }
                  });
                },
              ),

              const SizedBox(height: 16),

              // Multiple Crop Selection
              const Text('Crops*', style: TextStyle(fontSize: 16)),
              Wrap(
                spacing: 8.0,
                children: crops.map((String crop) {
                  return ChoiceChip(
                    label: Text(crop),
                    selected: _selectedCrops.contains(crop),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedCrops.add(crop);
                        } else {
                          _selectedCrops.remove(crop);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),
              // Sowing Area Input Field
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Sowing Area *',
                ),
                onChanged: (value) {
                  setState(() {
                    _sowingArea = double.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Unit of Measurement Dropdown
              const Text('Unit of Measurement*',
                  style: TextStyle(fontSize: 16)),
              DropdownButton<String>(
                value: _selectedUnitOfMeasurement,
                hint: const Text('Select Unit of Measurement'),
                isExpanded: true,
                items: unitsOfMeasurement.map((String unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUnitOfMeasurement = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              CountryPickerDropdown(
                initialValue: 'IN',
                itemBuilder: _buildDropdownItem,
                onValuePicked: (Country? country) {
                  setState(() {
                    _selectedCountryCurrency = country;
                  });
                  if (kDebugMode) {
                    print(
                        "Selected country: ${country?.name}, Currency: ${country?.currencyCode}");
                  }
                },
                itemFilter: (country) => country.currencyCode!.isNotEmpty,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 40,
                width: 40,
                child: Image.asset(''),
              ),
              const SizedBox(height: 16),
              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownItem(Country country) {
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        const SizedBox(width: 8.0),
        Text("${country.name} (${country.currencyCode})"),
      ],
    );
  }
}
