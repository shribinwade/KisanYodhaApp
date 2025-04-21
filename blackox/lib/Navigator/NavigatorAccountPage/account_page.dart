import 'package:blackox/Authentication%20Screen/authentication_screen.dart';
import 'package:blackox/Services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String _email = '';
  String image_url = '';
  String _mobile = '';
  String _name = '';

  @override
  void initState() {
    super.initState();
    _retrieveUserData();
  }

  Future<void> _retrieveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('Email') ?? '';
    });
    fetchUserData(_email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 60,
                backgroundImage: image_url.isNotEmpty
                    ? NetworkImage(image_url)
                    : const AssetImage('assets/Images/profile.png')
                        as ImageProvider,
              ),
              const SizedBox(height: 20),

              // Name
              Text(
                _name.isNotEmpty ? _name : 'Loading...',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Email
              Text(
                _email,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),

              // Mobile Number
              Text(
                _mobile.isNotEmpty ? 'Mobile: $_mobile' : 'Mobile: Loading...',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),

              // Logout Button
              ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchUserData(String email) async {
    final databaseService = DatabaseService();
    final result = await databaseService.fetchUserData(email);

    if (result.isNotEmpty) {
      setState(() {
        _name = result[0]['name'];
        _mobile = result[0]['number'];
        _email = result[0]['email'];
        image_url = result[0]['image_url'];
      });
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthenticationScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
