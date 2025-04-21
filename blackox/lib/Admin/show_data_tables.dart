import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowDataTables extends StatefulWidget {
  final String tableName;

  const ShowDataTables({super.key, required this.tableName});

  @override
  State<ShowDataTables> createState() => _ShowDataTablesState();
}

class _ShowDataTablesState extends State<ShowDataTables> {
  late Future<Map<String, dynamic>> _data;

  @override
  void initState() {
    super.initState();
    _data = fetchData(widget.tableName);
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data: ${widget.tableName}')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final columns = snapshot.data!['columns'].cast<String>();
            final rows = snapshot.data!['rows'];

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: columns.map<DataColumn>((column) {
                  return DataColumn(label: Text(capitalizeFirstLetter(column)));
                }).toList(),
                rows: rows.map<DataRow>((row) {
                  return DataRow(
                      cells: columns.map<DataCell>((column) {
                    return DataCell(
                      Text(row[column].toString()),
                      showEditIcon: true,
                      onTap: () {
                        _showEditDialog(row, columns);
                      },
                    );
                  }).toList());
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> item, List<String> columns) {
    final controllers = columns.map((column) {
      return TextEditingController(text: item[column].toString());
    }).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: columns.asMap().entries.map((entry) {
                final index = entry.key;
                final column = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: controllers[index],
                    decoration: InputDecoration(labelText: column),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final updatedItem = {
                    for (var i = 0; i < columns.length; i++)
                      columns[i]: controllers[i].text
                  };
                  final id = item['id'] ??
                      item['ID'] ??
                      item[
                          'Id']; // Adjust if your ID field has a different name
                  if (id != null) {
                    await updateData(
                        widget.tableName, id.toString(), updatedItem);
                    setState(() {
                      _data = fetchData(widget.tableName);
                    });
                    Navigator.of(context).pop();
                  } else {
                    throw Exception('ID field is missing in the item.');
                  }
                } catch (e) {
                  print('Error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update data: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> fetchData(String table) async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/data/$table'));

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> updateData(
      String table, String id, Map<String, dynamic> data) async {
    print('Updating data for $table with ID $id');
    print('Data: ${jsonEncode(data)}');

    final response = await http.put(
      Uri.parse('http://localhost:3000/update/$table/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to update data');
    }
  }
}
