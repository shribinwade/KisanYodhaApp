import 'package:blackox/Constants/screen_utility.dart';
import 'package:flutter/material.dart';

class LetStartedScreen extends StatelessWidget {
  const LetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get dynamic screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center horizontally
              children: [
                // First side image
                Flexible(
                  flex: 1,
                  child: Image.asset(
                    "assets/Images/KisanYodhaEng.png",
                    fit: BoxFit.fitWidth,
                    width: screenWidth * 0.9,
                  ),
                ),
              ],
            ),
            // SizedBox(height: screenHeight * 0.10),
            // SizedBox(height: screenHeight * 0.10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/selectionScreen');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1,
                  vertical: screenHeight * 0.02,
                ),
              ),
              child: const Text(
                "Let Started",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            const Text(
              '"Cultivating knowledge starts here"',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
