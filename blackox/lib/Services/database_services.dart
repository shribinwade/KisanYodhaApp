import 'dart:convert';

import 'package:blackox/Model/Advisor_details.dart';
import 'package:blackox/Model/GetUnit.dart';
import 'package:blackox/Model/bom_item.dart';
import 'package:blackox/Model/business_details.dart';
import 'package:blackox/Model/category_type.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:postgres/postgres.dart';

class DatabaseService {
  final connection = Connection.open(
    Endpoint(
      host: '34.71.87.187',
      port: 5432,
      database: 'datagovernance',
      username: 'postgres',
      password: 'India@5555',
    ),
    settings: const ConnectionSettings(sslMode: SslMode.disable),
  );
  final String baseUrl = dotenv.env['API_BASE_URL'] ??
      'https://blackox.passionit.com/black_ox_api';
  final String mentorBaseUrl =
      dotenv.env['MENTOR_BASE_URL'] ?? 'https://mentor.passionit.com';

  Future<bool> registerUser(String name, String password, String email,
      String number, String imageUrl) async {
    final url = Uri.parse('$baseUrl/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'password': password,
        'email': email,
        'number': number,
        'image_url': imageUrl,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      return false;
    }
  }

  Future<List<BusinessDetails>> getBusinessDetails() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/businessDetails'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Response Data: ${response.body}');
        return data.map((json) => BusinessDetails.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load business details');
      }
    } catch (e) {
      print('Error fetching business details: $e');
      return [];
    }
  }

  Future<List<AdvisorDetails>> getALlAdvisorDetails() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/advisory_details'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Response Data: ${response.body}');

        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> data = responseData['data'];
          return data.map((json) => AdvisorDetails.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load advisor details');
      }
    } catch (e) {
      print('Error fetching advisor details: $e');
      return [];
    }
  }

  Future<List<CategoryType>> getCategoryType() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categoryTypes'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => CategoryType.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load category types');
      }
    } catch (e) {
      print('Error fetching category types: $e');
      return [];
    }
  }

  Future<bool> fetchUserCredentials(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        final responseData = jsonDecode(response.body);
        return response.statusCode == 200 && responseData['success'];
      } else {
        print('Unexpected content-type: ${response.headers['content-type']}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error fetching credentials: $e');
      return false;
    }
  }

  Future<List<dynamic>> fetchUserData(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user-data?email=$email'), // Use your server's URL
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success']) {
        return responseData['data'];
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return [];
    }
  }

  Future<List<BOMItem>> fetchBOMItems(String bomCode, String bomId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bom/$bomCode/$bomId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => BOMItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load BOM items');
    }
  }

  Future<List<GetUnit>> fetchBOMGetUnit(String bomCode, String bomId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/getUnit/$bomCode/$bomId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => GetUnit.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load BOM items');
    }
  }

  // Fetch Soil Types based on location
  Future<List<String>> fetchSoilTypes({
    required String country,
    required String state,
    required String district,
    required String taluka,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/getSoilTypes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'country': country,
        'state': state,
        'district': district,
        'taluka': taluka,
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> soilTypes = json.decode(response.body);
      return soilTypes.map((soilType) => soilType.toString()).toList();
    } else {
      throw Exception('Failed to load soil types');
    }
  }

  Future<List<String>> fetchCropCategories({
    required String country,
    required String state,
    required String district,
    required String taluka,
    required String soilType,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/getCropCategories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'country': country,
        'state': state,
        'district': district,
        'taluka': taluka,
        'soilType': soilType,
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> categories = json.decode(response.body);
      return categories.map((category) => category.toString()).toList();
    } else {
      throw Exception('Failed to load crop categories');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCrops({
    required String country,
    required String state,
    required String district,
    required String taluka,
    required String soilType,
    required String cropCategory,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/getCrops'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'country': country,
        'state': state,
        'district': district,
        'taluka': taluka,
        'soilType': soilType,
        'cropCategory': cropCategory,
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> crops = json.decode(response.body);
      return crops.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load crops');
    }
  }

  Future<Map<String, dynamic>> fetchBOMBySoilCode(String soilCode) async {
    final response = await http.get(Uri.parse('$baseUrl/bom/$soilCode'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load BOM data');
    }
  }

  // Fetch list of countries
  Future<List<String>> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/countries'));
      if (response.statusCode == 200) {
        List<dynamic> countries = json.decode(response.body);
        return countries.cast<String>();
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (error) {
      throw Exception('Error fetching countries: $error');
    }
  }

  // Fetch list of states by country
  Future<List<String>> fetchStates(String country) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/states/$country'));
      if (response.statusCode == 200) {
        List<dynamic> states = json.decode(response.body);
        return states.cast<String>();
      } else {
        throw Exception('Failed to load states');
      }
    } catch (error) {
      throw Exception('Error fetching states: $error');
    }
  }

  // Fetch list of districts by state
  Future<List<String>> fetchDistricts(String state) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/districts/$state'));
      if (response.statusCode == 200) {
        List<dynamic> districts = json.decode(response.body);
        return districts.cast<String>();
      } else {
        throw Exception('Failed to load districts');
      }
    } catch (error) {
      throw Exception('Error fetching districts: $error');
    }
  }

  // Fetch list of talukas by district
  Future<List<String>> fetchTalukas(String district) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/talukas/$district'));
      if (response.statusCode == 200) {
        List<dynamic> talukas = json.decode(response.body);
        return talukas.cast<String>();
      } else {
        throw Exception('Failed to load talukas');
      }
    } catch (error) {
      throw Exception('Error fetching talukas: $error');
    }
  }

  Future<bool> registerBusinessDetails(
    String uName,
    String uNumber,
    String uEmail,
    String bName,
    String bAddress,
    int bPinCode,
    String bCity,
    String gstNO,
    String categoryType,
    String productName,
    int rate,
    String ratePer,
    String discountRate,
    DateTime startDate,
    DateTime endDate,
    DateTime registerDate,
    String imageUrl,
  ) async {
    final url = Uri.parse('$baseUrl/registerBusiness');

    final body = jsonEncode({
      'uName': uName,
      'uNumber': uNumber,
      'uEmail': uEmail,
      'bName': bName,
      'bAddress': bAddress,
      'bPinCode': bPinCode,
      'bCity': bCity,
      'gstNO': gstNO,
      'categoryType': categoryType,
      'productName': productName,
      'rate': rate,
      'ratePer': ratePer,
      'discountRate': discountRate,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'registerDate': registerDate.toIso8601String(),
      'imageUrl': imageUrl,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to register business: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
