import 'package:blackox/Authentication%20Screen/authentication_screen.dart';
import 'package:blackox/Constants/screen_utility.dart';
import 'package:flutter/material.dart';
import 'package:blackox/Navigator/NavigatorAccountPage/account_page.dart';
import 'package:blackox/Navigator/NavigatorAddPage/add_page.dart';
import 'package:blackox/Navigator/NavigatorCategories/categories_page.dart';
import 'package:blackox/Navigator/NavigatorHome/home_page.dart';
import 'package:blackox/Navigator/NavigatorNotification/notification_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _currentDate = '';
  late Timer _timer;
  Timer? _weatherTimer;

  // Weather variables
  String? _weatherLocation = 'Unknown';
  String? _weatherCondition = 'Unknown';
  double? _weatherTemperature;

  // Location variables
  Position? _currentPosition;

  // PageController for managing tab views
  final PageController _pageController = PageController();

  // Pages for each tab
  final List<Widget> _pages = [
    const HomePage(),
    const CategoriesPage(),
    const AddPage(),
    const NotificationPage(),
    const AccountPage(),
  ];

  // Manage visibility of navigation bar
  bool _showBottomNavBar = true;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer =
        Timer.periodic(const Duration(seconds: 60), (Timer t) => _updateTime());
    _initializeLocationAndWeather();
  }

  Future<void> _initializeLocationAndWeather() async {
    // Delay the location check slightly to allow the UI to render first
    await Future.delayed(const Duration(milliseconds: 500));
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _timer.cancel();
    _weatherTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorDialog('Location services are disabled.');
        return;
      }

      // Check for location permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        _showErrorDialog(
            'Location permissions are permanently denied, we cannot request permissions.');
        return;
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          _showErrorDialog(
              'Location permissions are denied (actual value: $permission).');
          return;
        }
      }

      // Get the current location
      await _getLocation();

      // Set up periodic weather updates
      _weatherTimer = Timer.periodic(
        const Duration(minutes: 15),
        (Timer t) => _fetchWeather(),
      );
    } catch (e) {
      print("Error in location permission check: $e");
    }
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
        await _fetchWeather();
      }
    } catch (e) {
      print("Failed to get location: $e");
    }
  }

  Future<void> _fetchWeather() async {
    if (_currentPosition != null) {
      double lat = _currentPosition!.latitude;
      double lon = _currentPosition!.longitude;
      print('Fetching weather for coordinates: lat=$lat, lon=$lon');
      await _fetchCityName(lat, lon);
      await _fetchWeatherData(lat, lon);
    } else {
      print('Current position is null');
    }
  }

  Future<void> _fetchCityName(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      print('Fetched placemarks: ${placemarks.length}');
      if (placemarks.isNotEmpty && mounted) {
        print('City name: ${placemarks[0].locality}');
        setState(() {
          _weatherLocation = placemarks[0].locality;
        });
      }
    } catch (e) {
      print('Error fetching city name: $e');
    }
  }

  Future<void> _fetchWeatherData(double lat, double lon) async {
    String apiUrl =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true';
    print('Fetching weather data from: $apiUrl');

    try {
      http.Response response = await http.get(Uri.parse(apiUrl));
      print('Weather API response status: ${response.statusCode}');

      if (response.statusCode == 200 && mounted) {
        var jsonResponse = json.decode(response.body);
        var weatherData = jsonResponse['current_weather'];
        print('Weather data received: $weatherData');

        setState(() {
          _weatherCondition = weatherData['weathercode'].toString();
          _weatherTemperature = weatherData['temperature'];
        });
        print(
            'Updated weather state: condition=$_weatherCondition, temperature=$_weatherTemperature');
      } else {
        print('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  void _updateTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat('MMM d').format(now); // Date format
    setState(() {
      _currentDate = formattedDate;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex == 0) {
      return true;
    } else {
      _onItemTapped(0); // Navigate to the first tab
      return false;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogout() async {
    // Perform logout logic here
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthenticationScreen()),
      (Route<dynamic> route) => false, // Remove all routes
    );
    setState(() {
      // _showBottomNavBar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Building HomeScreen with:');
    print('Location: $_weatherLocation');
    print('Temperature: $_weatherTemperature');
    print('Condition: $_weatherCondition');
    print('Current Date: $_currentDate');
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side - Date
              Text(
                _currentDate,
                style: const TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
              // Right side - Location and Temperature
              Row(
                children: [
                  Icon(Icons.wb_cloudy,
                      color: const Color.fromARGB(255, 252, 244, 33)),
                  SizedBox(width: ScreenUtility.screenWidth * 0.02),
                  Text(
                    '$_weatherLocation',
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: ScreenUtility.screenWidth * 0.02),
                  if (_weatherLocation != null &&
                      _weatherCondition != null &&
                      _weatherTemperature != null)
                    Text(
                      '$_weatherTemperature°C',
                      style: const TextStyle(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ],
          ),
          backgroundColor: Colors.orange,
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.orange,
                ),
                child: Text(
                  'Side Nav',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              const ListTile(
                leading: Icon(Icons.message),
                title: Text('Messages'),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Profile'),
                onTap: () {
                  _onItemTapped(4); // Navigate to Account Page
                },
              ),
              const ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                onTap: () {
                  _handleLogout(); // Handle logout
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _pages,
              ),
            ),
          ],
        ),
        bottomNavigationBar: _showBottomNavBar
            ? BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.category),
                    label: 'Categories',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add),
                    label: 'Add',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.notifications),
                    label: 'Notifications',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: 'Account',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.orange,
                onTap: _onItemTapped,
              )
            : null,
      ),
    );
  }
}
