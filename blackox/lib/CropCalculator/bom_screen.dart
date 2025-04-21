import 'package:blackox/Model/GetUnit.dart';
import 'package:blackox/Model/bom_item.dart';
import 'package:blackox/Services/database_services.dart';
import 'package:flutter/material.dart';

class BOMScreen extends StatefulWidget {
  final List<Map<String, String>> bomData; // List of BOM data
  final String name;
  final double sowingArea;
  final String unitOfMeasure;

  const BOMScreen({
    super.key,
    required this.bomData,
    required this.name,
    required this.sowingArea,
    required this.unitOfMeasure,
  });

  @override
  State<BOMScreen> createState() => _BOMScreenState();
}

class _BOMScreenState extends State<BOMScreen> {
  late List<Future<List<BOMItem>>> futureBOMItemsList;
  late List<Future<List<GetUnit>>>
      futureBOMUnitList; // Future to hold unit data
  DatabaseService dbService = DatabaseService();
  late String? cropName = '';

  @override
  void initState() {
    super.initState();
    // Fetch both BOM items and their unit data
    futureBOMItemsList = widget.bomData.map((bom) {
      return dbService.fetchBOMItems(bom['bomCode']!, bom['bomId']!);
    }).toList();

    futureBOMUnitList = widget.bomData.map((bom) {
      return dbService.fetchBOMGetUnit(bom['bomCode']!, bom['bomId']!);
    }).toList();

    cropName = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$cropName - Bill of Materials'),
      ),
      body: ListView.builder(
        itemCount: futureBOMItemsList.length,
        itemBuilder: (context, index) {
          // FutureBuilder to fetch both BOM items and their corresponding unit data
          return FutureBuilder<List<BOMItem>>(
            future: futureBOMItemsList[index],
            builder: (context, bomSnapshot) {
              if (bomSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (bomSnapshot.hasError) {
                return Center(child: Text('Error: ${bomSnapshot.error}'));
              } else if (!bomSnapshot.hasData || bomSnapshot.data!.isEmpty) {
                return const Center(child: Text('No data available'));
              } else {
                final bomItems = bomSnapshot.data!;

                // Fetch unit data in a nested FutureBuilder
                return FutureBuilder<List<GetUnit>>(
                  future: futureBOMUnitList[index],
                  builder: (context, unitSnapshot) {
                    if (unitSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (unitSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${unitSnapshot.error}'));
                    } else if (!unitSnapshot.hasData ||
                        unitSnapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No unit data available'));
                    } else {
                      final getUnits = unitSnapshot.data!;
                      final unit =
                          getUnits.first; // Assuming only one unit per BOM

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBOMHeader(index),
                          ..._buildItemRows(bomItems, unit),
                          // Pass the unit data
                          const SizedBox(height: 16),
                          _buildCostSummary(bomItems, unit),
                          // Use unit data for calculations
                          const Divider(),
                        ],
                      );
                    }
                  },
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildBOMHeader(int index) {
    // Assuming bomData contains a description or name of the BOM
    String? bomName = widget.bomData[index]['crop'];

    return Container(
      color: Colors.blueAccent.withOpacity(0.1),
      padding: const EdgeInsets.all(8.0),
      child: Text(
        bomName!, // Use the BOM name here
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  List<Widget> _buildItemRows(List<BOMItem> bomItems, GetUnit unit) {
    return List.generate(bomItems.length, (index) {
      final item = bomItems[index];

      // Check if the user's unit of measure matches the database unit of measure
      double adjustedSowingArea = widget.sowingArea;
      if (widget.unitOfMeasure != unit.cropUnitMeasure) {
        // Convert the sowing area to match the BOM's unit of measure
        adjustedSowingArea = convertUnits(
            widget.sowingArea, widget.unitOfMeasure, unit.cropUnitMeasure);
      }

      // Calculate the scale factor based on the adjusted sowing area and the cropUnitArea from the database
      double scaleFactor = adjustedSowingArea / unit.cropUnitArea;

      // Adjust quantity and cost based on the scale factor
      double adjustedQty = item.qty * scaleFactor;
      double adjustedCost = item.totalCost * scaleFactor;

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: index % 2 == 0
              ? Colors.blueAccent.withOpacity(0.05)
              : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: Text('${index + 1}')),
            Expanded(flex: 3, child: Text(item.itemName)),
            Expanded(
                child: Text('${adjustedQty.toStringAsFixed(2)} ${item.uom}')),
            Expanded(child: Text('₹ ${adjustedCost.toStringAsFixed(2)}')),
          ],
        ),
      );
    });
  }

  Widget _buildCostSummary(List<BOMItem> bomItems, GetUnit unit) {
    // Convert sowing area if the units don't match
    double adjustedSowingArea = widget.sowingArea;
    if (widget.unitOfMeasure != unit.cropUnitMeasure) {
      adjustedSowingArea = convertUnits(
          widget.sowingArea, widget.unitOfMeasure, unit.cropUnitMeasure);
    }

    // Calculate total costs and apply scaling
    double totalProductionCost =
        bomItems.fold(0, (sum, item) => sum + item.totalCost);
    double seedsSubsidy = bomItems.fold(0, (sum, item) => sum + item.subsidy);
    double scaleFactor = adjustedSowingArea / unit.cropUnitArea;

    // Adjust the costs based on the scaling factor
    totalProductionCost *= scaleFactor;
    seedsSubsidy *= scaleFactor;
    double finalProductionCost = totalProductionCost - seedsSubsidy;

    return Container(
      color: Colors.redAccent.withOpacity(0.2),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          _buildSummaryRow('Total Production Cost:', totalProductionCost),
          _buildSummaryRow('Subsidy:', seedsSubsidy, isSubsidy: true),
          const SizedBox(height: 8),
          _buildSummaryRow('Final Production Cost:', finalProductionCost,
              isFinalCost: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount,
      {bool isSubsidy = false, bool isFinalCost = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isFinalCost ? 20 : 18,
            fontWeight: isFinalCost ? FontWeight.bold : FontWeight.normal,
            color: isSubsidy ? Colors.green : Colors.black,
          ),
        ),
        Text(
          '${isSubsidy ? '- ' : ''}₹ ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isFinalCost ? 20 : 18,
            fontWeight: isFinalCost ? FontWeight.bold : FontWeight.normal,
            color: isSubsidy
                ? Colors.green
                : (isFinalCost ? Colors.green : Colors.black),
          ),
        ),
      ],
    );
  }

  double convertUnits(double area, String fromUnit, String toUnit) {
    // Define conversion factors
    const double acresToHectares = 0.404686;
    const double hectaresToAcres = 2.47105;

    // Add more conversion rates if needed

    // Perform conversion based on the units
    if (fromUnit == 'Acre' && toUnit == 'Hectare') {
      return area * acresToHectares;
    } else if (fromUnit == 'Hectare' && toUnit == 'Acre') {
      return area * hectaresToAcres;
    } else {
      // If units are the same, no conversion is needed
      return area;
    }
  }
}
