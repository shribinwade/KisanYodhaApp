import 'dart:async';

import 'package:blackox/Authentication%20Screen/authentication_screen.dart';
import 'package:blackox/Constants/screen_utility.dart';
import 'package:flutter/material.dart';

class AccountComplete extends StatefulWidget {
  final String username;

  const AccountComplete({super.key, required this.username});

  @override
  State<AccountComplete> createState() => _AccountCompleteState();
}

class _AccountCompleteState extends State<AccountComplete> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 4),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthenticationScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: ScreenUtility.screenHeight * 0.1),
          Image.asset("assets/Images/BlackOxLogo.png"),
          SizedBox(
            height: ScreenUtility.screenHeight * 0.05,
          ),
          const Text(
            "Confirm ! ",
            style: TextStyle(
                fontSize: 50,
                color: Colors.green,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold),
          ),
          const Text("Congratulations",
              style: TextStyle(
                  fontSize: 50,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold)),
          Text.rich(
            TextSpan(
              text: "Welcome ",
              style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal),
              children: <TextSpan>[
                TextSpan(
                  text: widget.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: " to Our BlackOx Family!",
                ),
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtility.screenHeight * 0.05,
          ),
          Image.asset(
            "assets/Images/account_complete.png",
            height: ScreenUtility.screenHeight * 0.15,
            fit: BoxFit.fitHeight,
          ),
          SizedBox(
            height: ScreenUtility.screenHeight * 0.1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/Icon/FacebookIcon.png"),
              const SizedBox(width: 10),
              Image.asset("assets/Icon/googleIcon.png"),
              const SizedBox(width: 10),
              Image.asset("assets/Icon/InstagramIcon.png"),
              const SizedBox(width: 10),
              Image.asset("assets/Icon/WhatsAppIcon.png"),
            ],
          ),
        ],
      ),
    );
  }
}
