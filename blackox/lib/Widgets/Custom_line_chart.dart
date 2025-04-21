import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatelessWidget {
  final List<FlSpot> data;
  final List<String> xLabels;
  final Color lineColor;

  const CustomLineChart({
    super.key,
    required this.data,
    required this.xLabels,
    required this.lineColor, // default color
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(2),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: LineChart(LineChartData(
            gridData: _buildGridData(),
            borderData: _buildBorderData(),
            titlesData: _buildTitlesData(),
            lineBarsData: [
              _buildLineChartBarData(),
            ])),
      ),
    );
  }

  FlGridData _buildGridData() {
    return const FlGridData(
        show: false,
        drawHorizontalLine: true,
        drawVerticalLine: true,
        verticalInterval: 1);
  }

  FlBorderData _buildBorderData() {
    return FlBorderData(
        show: true, border: Border.all(color: Colors.black, width: 1));
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            minIncluded: false,
            maxIncluded: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index >= 0 && index < xLabels.length) {
                return Text(xLabels[index].substring(0, 3));
              }
              return const Text('');
              // return Text("Month ${value.toInt()}");
            }),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false, reservedSize: 40),
      ),
    );
  }

  LineChartBarData _buildLineChartBarData() {
    return LineChartBarData(
        spots: data,
        color: lineColor,
        barWidth: 2,
        isCurved: false,
        belowBarData: BarAreaData(
            show: false,
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [lineColor.withOpacity(0.3), lineColor.withOpacity(0.6)],
            )));
  }
}
