import 'package:blackox/CropCalculator/crop_calculator.dart';
import 'package:blackox/CropPriceForeCasting/cropSelectionPage.dart';
import 'package:blackox/Navigator/NavigatorHome/business_details_shops.dart';
import 'package:blackox/Navigator/NavigatorHome/advisor_details.dart';
import 'package:flutter/material.dart';
import 'package:blackox/Constants/screen_utility.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: 10,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRectangularButton('assets/Icon/Calculator.png', context,
                  width: ScreenUtility.screenWidth * 0.28,
                  height: ScreenUtility.screenHeight * 0.15),
              _buildRectangularButton('assets/Icon/plus_icon.png', context,
                  width: ScreenUtility.screenWidth * 0.28,
                  height: ScreenUtility.screenHeight * 0.15),
              _buildRectangularButton('assets/Icon/rupeesIcon.png', context,
                  width: ScreenUtility.screenWidth * 0.28,
                  height: ScreenUtility.screenHeight * 0.15),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildRectangularButtonText(
                          'assets/Icon/plus_icon.png', 'Crop Add', context,
                          width: ScreenUtility.screenWidth * 0.44,
                          height: ScreenUtility.screenHeight * 0.15),
                      _buildRectangularButtonText('assets/Icon/Calculator.png',
                          'Crop Calculator', context,
                          width: ScreenUtility.screenWidth * 0.44,
                          height: ScreenUtility.screenHeight * 0.15),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildRectangularButtonText(
                          'assets/Icon/Emblem_of_India.png',
                          'Government Schema',
                          context,
                          width: ScreenUtility.screenWidth * 0.44,
                          height: ScreenUtility.screenHeight * 0.15),
                      _buildRectangularButtonText(
                          'assets/Icon/tractor_icon.png',
                          'Farmers Community',
                          context,
                          width: ScreenUtility.screenWidth * 0.44,
                          height: ScreenUtility.screenHeight * 0.15),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildRectangularButtonText(
                          'assets/Icon/agriculture_icon.png',
                          'Advisor Community',
                          context,
                          width: ScreenUtility.screenWidth * 0.44,
                          height: ScreenUtility.screenHeight * 0.15),
                      _buildRectangularButtonText(
                          'assets/Icon/exporters_icon.png',
                          'Exporters',
                          context,
                          width: ScreenUtility.screenWidth * 0.44,
                          height: ScreenUtility.screenHeight * 0.15),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildRectangularButtonText(
                          'assets/Icon/drone_icon.png', 'Agri Startup', context,
                          width: ScreenUtility.screenWidth * 0.44,
                          height: ScreenUtility.screenHeight * 0.15),
                      _buildRectangularButtonText(
                          'assets/Icon/businessIcon.png', 'Business', context,
                          width: ScreenUtility.screenWidth * 0.44,
                          height: ScreenUtility.screenHeight * 0.15),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRectangularButton(String imagePath, BuildContext context,
      {double width = 15, double height = 15}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: () {
            if (imagePath == 'assets/Icon/Calculator.png') {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CropCalculator(),
              ));
            } else if (imagePath == 'assets/Icon/rupeesIcon.png') {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CropForeCastingScreen(),
              ));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Button pressed')));
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color(0xFFB799FF),
            minimumSize: Size(width, height),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Center(
            child: Image.asset(imagePath,
                width: 60, height: 60, fit: BoxFit.fitHeight),
          ),
        ),
      ),
    );
  }

  Widget _buildRectangularButtonText(
      String imagePath, String title, BuildContext context,
      {double width = 15, double height = 15}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: () async {
            if (title == 'Business') {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const BusinessDetailsShops(),
              ));
            } else if (title == 'Advisor Community') {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(
              //     content: Text('Advisor Community route clicked'),
              //     duration: Duration(seconds: 2),
              //   ),
              // );
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AdvisorDetailsScreen(),
              ));
            } else if (title == 'Farmers Community') {
              final Uri url = Uri.parse('https://aspen.passionframework.com/');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not launch website'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color(0xFF89CFF3),
            minimumSize: Size(width, height),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath,
                  width: 40, height: 40, fit: BoxFit.fitHeight),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
