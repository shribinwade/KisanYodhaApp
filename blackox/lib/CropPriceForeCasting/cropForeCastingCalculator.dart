import 'package:blackox/CropPriceForeCasting/cropForeCastingPage.dart';
import 'package:flutter/material.dart';
import 'package:blackox/Constants/screen_utility.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class CropForeCastingCalculatorScreen extends StatefulWidget {
  const CropForeCastingCalculatorScreen({super.key});

  @override
  State<CropForeCastingCalculatorScreen> createState() =>
      _CropForeCastingCalculatorScreenState();
}

class _CropForeCastingCalculatorScreenState
    extends State<CropForeCastingCalculatorScreen> {
  String? selectedCrop;
  String? selectedLocation;
  String? selectedSeason;
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;
  String _error = '';

  List<String> crops = [];
  List<String> locations = [];
  List<String> seasons = []; // Changed from final to regular List
  // bool isLoadingCrops = false;

  @override
  void initState() {
    super.initState();
    fetchCrops(); // Fetch crops when screen initializes
  }

  final String baseUrl = dotenv.env['API_BASE_URL'] ??
      'https://blackox.passionit.com/black_ox_api';

  // Sample data for dropdowns
  // final List<String> crops = [
  //   'Wheat',
  //   'Rice',
  //   'Corn',
  //   'Soybeans',
  //   'Cotton',
  //   'Potato',
  //   'Tomato',
  //   'Onion',
  // ];

  // final List<String> locations = [
  //   'Maharashtra',
  //   'Gujarat',
  //   'Karnataka',
  //   'Tamil Nadu',
  //   'Uttar Pradesh',
  //   'Madhya Pradesh',
  //   'Rajasthan',
  //   'Punjab',
  //   'Haryana',
  //   'Bihar',
  //   'West Bengal',
  //   'Andhra Pradesh',
  //   'Telangana',
  //   'Kerala',
  //   'Odisha',
  //   'Assam',
  //   'Chhattisgarh',
  //   'Jharkhand',
  //   'Uttarakhand',
  //   'Himachal Pradesh',
  // ];

  // final List<String> seasons = [
  //   'Kharif',
  //   'Rabi',
  // ];

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime.now().add(const Duration(days: 365)),
  //   );
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //     });
  //   }
  // }

  Future<void> fetchCrops() async {
    setState(() {
      isLoading = true;
    });

    try {
      final cropresponse = await http.get(Uri.parse('$baseUrl/allcrops'));
      final locationResponse = await http.get(Uri.parse('$baseUrl/allstates'));
      final seasonResponse = await http.get(Uri.parse('$baseUrl/allseasons'));

      if (cropresponse.statusCode == 200 &&
          locationResponse.statusCode == 200 &&
          seasonResponse.statusCode == 200) {
        final List<dynamic> cropsList = json.decode(cropresponse.body);
        final List<dynamic> locationList = json.decode(locationResponse.body);
        final List<dynamic> seasonList = json.decode(seasonResponse.body);
        setState(() {
          crops = cropsList.map((crop) => crop.toString()).toList();
          locations =
              locationList.map((location) => location.toString()).toList();
          seasons = seasonList.map((season) => season.toString()).toList();
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to fetch data'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _selectMonthYear(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Set the day to 1 since we only care about month and year
        selectedDate = DateTime(picked.year, picked.month, 1);
      });
    }
  }

  Future<void> _getForecast() async {
    if (selectedCrop == null ||
        selectedLocation == null ||
        selectedSeason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/cropDataWithPriceHistory'), // Replace with your actual API endpoint
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'crop_name': selectedCrop,
          'year': selectedDate.toIso8601String(),
          'state': selectedLocation,
          'season_name': selectedSeason,
          'country': "India"
        }),
      );

      if (response.statusCode == 200) {
        // Navigate to the forecast result page
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CropForeCastingPage(
                forecastData: jsonDecode(response.body),
                crop: selectedCrop ?? '',
                location: selectedLocation ?? '',
                season: selectedSeason ?? '',
                date: selectedDate,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Price Forecasting Calculator'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Crop Price Forecasting",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),

                        const SizedBox(height: 8),
                        // Label for Sowing Month
                        const Text(
                          "Select Crop: ",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Crop Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: isLoading
                                ? const Center(
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : DropdownButton<String>(
                                    hint: const Text('Select Crop'),
                                    value: selectedCrop,
                                    isExpanded: true,
                                    items: crops.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedCrop = newValue;
                                      });
                                    },
                                  ),
                          ),
                        ),

                        const SizedBox(height: 8),
                        // Label for Sowing Month
                        const Text(
                          "Select Location: ",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Location Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: const Text('Select Location'),
                              value: selectedLocation,
                              isExpanded: true,
                              items: locations.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedLocation = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Label for Sowing Month
                        const Text(
                          "Select Season: ",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Season Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: const Text('Select Season'),
                              value: selectedSeason,
                              isExpanded: true,
                              items: seasons.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedSeason = newValue;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),
                        // Label for Sowing Month
                        const Text(
                          "Sowing Month: ",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Date Picker
                        // Month Year Picker
                        InkWell(
                          onTap: () => _selectMonthYear(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('MMM yyyy').format(selectedDate),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Forecast Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffdcfce7),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: isLoading ? null : _getForecast,
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.black),
                                    ),
                                  )
                                : const Text(
                                    'Get Forecast',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
