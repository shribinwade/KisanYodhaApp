import 'package:blackox/Constants/screen_utility.dart';

import 'package:blackox/Widgets/Custom_line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CropForeCastingPage extends StatelessWidget {
  final dynamic forecastData;
  final String crop;
  final String location;
  final String season;
  final DateTime date;
  bool isSowingRecommended = false;

  CropForeCastingPage({
    Key? key,
    required this.forecastData,
    required this.crop,
    required this.location,
    required this.season,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('forecastData: $forecastData');
    final cropInfo = forecastData['data']['crop_info'];
    final priceHistory = forecastData['data']['price_history'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Forecasting Results'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(5),
                width: ScreenUtility.screenWidth,
                // height: ScreenUtility.screenHeight,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(9, 30, 66, 0.25),
                                  blurRadius: 8,
                                  spreadRadius: -2,
                                  offset: Offset(0, 4),
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(9, 30, 66, 0.08),
                                  blurRadius: 0,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            width: ScreenUtility.screenHeight * 0.5,
                            child: Text(
                              cropInfo['season_name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(9, 30, 66, 0.25),
                                  blurRadius: 8,
                                  spreadRadius: -2,
                                  offset: Offset(0, 4),
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(9, 30, 66, 0.08),
                                  blurRadius: 0,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            width: ScreenUtility.screenHeight * 0.5,
                            child: Text(
                              cropInfo['crop_name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _chart1(priceHistory),
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.25),
                            blurRadius: 8,
                            spreadRadius: -2,
                            offset: Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.08),
                            blurRadius: 0,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      width: ScreenUtility.screenHeight * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sowing Month:',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${cropInfo['sowing_period']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.25),
                            blurRadius: 8,
                            spreadRadius: -2,
                            offset: Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.08),
                            blurRadius: 0,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      width: ScreenUtility.screenHeight * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Current Market Price:',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${cropInfo['current_market_price']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: cropInfo['predicted_market_price'] != null
                            ? Colors.green.shade100
                            : Colors.grey,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.25),
                            blurRadius: 8,
                            spreadRadius: -2,
                            offset: Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.08),
                            blurRadius: 0,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      width: ScreenUtility.screenHeight * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Predicted market price:',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${cropInfo['predicted_market_price']} per ${cropInfo['market_price_unit']} ',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.25),
                            blurRadius: 8,
                            spreadRadius: -2,
                            offset: Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.08),
                            blurRadius: 0,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      width: ScreenUtility.screenHeight * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Best selling market:',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${cropInfo['best_selling_market']} ',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.25),
                            blurRadius: 8,
                            spreadRadius: -2,
                            offset: Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.08),
                            blurRadius: 0,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      width: ScreenUtility.screenHeight * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'MSP(Govt. Support Price)',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${cropInfo['msp_price']} per ${cropInfo['market_price_unit']}  ',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.25),
                            blurRadius: 8,
                            spreadRadius: -2,
                            offset: Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.08),
                            blurRadius: 0,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      width: ScreenUtility.screenHeight * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Predicted Harvest Month',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${cropInfo['predicted_harvest_month']}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.25),
                            blurRadius: 8,
                            spreadRadius: -2,
                            offset: Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.08),
                            blurRadius: 0,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      width: ScreenUtility.screenHeight * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sow Rec.',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${cropInfo['sowing_recommendations']}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.25),
                            blurRadius: 8,
                            spreadRadius: -2,
                            offset: Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.08),
                            blurRadius: 0,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      width: ScreenUtility.screenHeight * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Ideal Soil Quality',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${cropInfo['ideal_soil_quality']}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.25),
                            blurRadius: 8,
                            spreadRadius: -2,
                            offset: Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.08),
                            blurRadius: 0,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      width: ScreenUtility.screenHeight * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Ideal Weather',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${cropInfo['ideal_weather_conditions']}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.25),
                            blurRadius: 8,
                            spreadRadius: -2,
                            offset: Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(9, 30, 66, 0.08),
                            blurRadius: 0,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      width: ScreenUtility.screenHeight * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sowing Recommended as per forecast',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isSowingRecommended
                                ? Icons.check_circle
                                : Icons.cancel,
                            color:
                                isSowingRecommended ? Colors.green : Colors.red,
                          ),
                        ],
                      ),
                    ),
                    // _buildPriceHistoryChart(priceHistory),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chart1(List<dynamic> priceHistory) {
    List<FlSpot> dataPoints = [];
    List<String> monthLabels = [];

    for (int i = 0; i < priceHistory.length; i++) {
      final item = priceHistory[i];
      final rawPrice = item['price_per_unit'];

      double price = 0.0;
      if (rawPrice is num) {
        price = rawPrice.toDouble();
      } else if (rawPrice is String) {
        price = double.tryParse(rawPrice) ?? 0.0;
      }

      dataPoints.add(FlSpot(i.toDouble(), price));
      monthLabels.add(item['month'] ?? '');
    }

    //Get Price Trend
    String trend = getPriceTrend(dataPoints);
    Color trendColor = getTrendColor(trend);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Price Trend: $trend',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
            height: ScreenUtility.screenHeight * 0.4,
            width: ScreenUtility.screenWidth,
            child: CustomLineChart(
              data: dataPoints,
              xLabels: monthLabels,
              lineColor: trendColor,
            )),
      ],
    );
  }

  String getPriceTrend(List<FlSpot> dataPoints) {
    if (dataPoints.length < 2) return 'No Trend';

    double start = dataPoints.first.y;
    double end = dataPoints.last.y;

    if (end > start) {
      isSowingRecommended = true;
      return 'Increasing';
    }
    if (end < start) {
      isSowingRecommended = false;
      return 'Decreasing';
    }
    isSowingRecommended = true;
    return 'Stable';
  }

  Color getTrendColor(String trend) {
    switch (trend) {
      case 'Increasing':
        return Colors.green;
      case 'Decreasing':
        return Colors.red;
      case 'Stable':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildInfoCard(
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceHistoryChart(List<dynamic> priceHistory) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...priceHistory
                .map((entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text('${entry['month']} ${entry['year']}'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              entry['price_per_unit'] != null
                                  ? '₹${entry['price_per_unit']}'
                                  : 'N/A',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: entry['price_per_unit'] != null
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
