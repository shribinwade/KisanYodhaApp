import 'dart:async';
import 'package:blackox/Constants/screen_utility.dart';
import 'package:blackox/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    Timer(
      const Duration(seconds: 3),
      () {
        if (isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          Navigator.pushNamed(context, '/letStartedScreen');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xD80CFFD2), Color(0xD8317766)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // First side image
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: ScreenUtility.screenWidth * 2.2,
                      height: ScreenUtility.screenHeight * 0.6,
                      child: Image.asset(
                        "assets/Images/KisanYodhaEng.png",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtility.screenWidth * 0.001,
                  ),
                  // Center image (slightly bigger)
                  // Flexible(
                  //   flex: 2, // Bigger flex for larger size
                  //   child: Image.asset(
                  //     "assets/Images/BlackOxLogo.png",
                  //     fit: BoxFit.fitWidth,
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: ScreenUtility.screenWidth *
                  //       0.05, // Space between images
                  // ),
                  // // Second side image
                  // Flexible(
                  //   flex: 1,
                  //   child: Image.asset(
                  //     "assets/Images/kisanYodhaHindi.png",
                  //     fit: BoxFit.fitWidth,
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(height: ScreenUtility.screenHeight * 0.06),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}
