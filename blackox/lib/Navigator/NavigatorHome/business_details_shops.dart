import 'package:blackox/Model/business_details.dart';
import 'package:blackox/Model/category_type.dart';
import 'package:blackox/Services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessDetailsShops extends StatefulWidget {
  const BusinessDetailsShops({super.key});

  @override
  State<BusinessDetailsShops> createState() => _BusinessDetailsShopsState();
}

class _BusinessDetailsShopsState extends State<BusinessDetailsShops> {
  final DatabaseService databaseService = DatabaseService();
  final TextEditingController _searchController = TextEditingController();
  final String _searchQuery = '';
  String? _selectedCategory;
  List<CategoryType> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await databaseService.getCategoryType();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      // Handle error appropriately
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (_selectedCategory != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    _selectedCategory!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: FutureBuilder<List<BusinessDetails>>(
              future: databaseService.getBusinessDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No business details available'));
                } else {
                  final businessDetailsList = snapshot.data!;
                  final filteredList = businessDetailsList.where((item) {
                    final itemName = item.bName?.toLowerCase();
                    final searchQuery = _searchQuery.toLowerCase();
                    final matchesSearchQuery = itemName?.contains(searchQuery);
                    final matchesCategory = _selectedCategory == null ||
                        item.categoryType == _selectedCategory;
                    return matchesSearchQuery! && matchesCategory;
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      // Fetch color string for category
                      final categoryColorString = _getCategoryColorString(
                          filteredList[index].categoryType ?? '');
                      final businessDetailImageUrl =
                          _getBusinessImageUrl(filteredList[index]);

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Color(
                              int.tryParse(categoryColorString) ?? 0xFFFFFFFF),
                          // Convert color string to Color object
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 100, // Adjust width as needed
                              height: 100, // Adjust height as needed
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(6),
                                // Adjust if you want rounded corners
                                image: DecorationImage(
                                  image: NetworkImage(
                                      businessDetailImageUrl ?? ''),
                                  // Use the correct image URL
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Space between image and text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filteredList[index].bName ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  const SizedBox(height: 4),
                                  // Space between text and rate info
                                  Text(
                                    '${filteredList[index].ratePer} - ${filteredList[index].rate}₹',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.phone_outlined,
                                  color: Colors.white),
                              onPressed: () {
                                _showPhoneNumber(
                                    context, filteredList[index].uNumber ?? '');
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryColorString(String categoryType) {
    final category = _categories.firstWhere(
        (element) => element.categoryName == categoryType,
        orElse: () => CategoryType(
            categoryName: categoryType, color: '#000000', imageIcon: ''));

    String colorString = category.color;

    // Extract hexadecimal color value from Color(0xffa00beb) format
    if (colorString.startsWith('Color(') && colorString.endsWith(')')) {
      colorString = colorString.substring(
          6, colorString.length - 1); // Remove 'Color(' and ')'
    }

    return colorString;
  }

  String? _getBusinessImageUrl(BusinessDetails businessDetail) {
    if (businessDetail.imageUrl!.isNotEmpty &&
        businessDetail.imageUrl != 'DEFAULT') {
      return businessDetail.imageUrl;
    } else {
      final category = _categories.firstWhere(
        (element) => element.categoryName == businessDetail.categoryType,
        orElse: () => CategoryType(
            categoryName: businessDetail.categoryType ?? '',
            color: '#000000',
            imageIcon: ''),
      );
      return category.imageIcon;
    }
  }

  void _showCategoryFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Category"),
          content: DropdownButton<String>(
            isExpanded: true,
            value: _selectedCategory,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue;
              });
              Navigator.of(context).pop();
            },
            items: <String>[
              ..._categories.map((category) => category.categoryName),
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showPhoneNumber(BuildContext context, String phoneNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Phone Number",
            style: TextStyle(fontSize: 30),
          ),
          content: Text(
            phoneNumber,
            style: const TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              child: const Text(
                "Call",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () async {
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: phoneNumber,
                );
                await launchUrl(launchUri);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
