import 'package:blackox/Admin/show_data_tables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UploadExcel extends StatefulWidget {
  const UploadExcel({super.key});

  @override
  State<UploadExcel> createState() => _UploadExcelState();
}

class _UploadExcelState extends State<UploadExcel> {
  Future<void> uploadCropBillofMaterial() async {
    try {
      // Pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Use bytes property for web
        final bytes = result.files.single.bytes;
        final fileName = result.files.single.name;

        if (bytes != null) {
          // Create a multipart request
          var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'http://localhost:3000/upload/agri_crop_bill_of_material'),
          );

          // Attach the file as bytes
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: fileName,
          ));

          // Send the request
          var response = await request.send();

          if (response.statusCode == 200) {
            print('File uploaded successfully.');
          } else {
            print('Failed to upload file. Status code: ${response.statusCode}');
          }
        } else {
          print('File content is empty.');
        }
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> uploadCropBOMDetail() async {
    try {
      // Pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Use bytes property for web
        final bytes = result.files.single.bytes;
        final fileName = result.files.single.name;

        if (bytes != null) {
          // Create a multipart request
          var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'http://localhost:3000/upload/agri_crop_bill_of_material_detail'),
          );

          // Attach the file as bytes
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: fileName,
          ));

          // Send the request
          var response = await request.send();

          if (response.statusCode == 200) {
            print('File uploaded successfully.');
          } else {
            print('Failed to upload file. Status code: ${response.statusCode}');
          }
        } else {
          print('File content is empty.');
        }
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> uploadDataImage() async {
    try {
      // Pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Use bytes property for web
        final bytes = result.files.single.bytes;
        final fileName = result.files.single.name;

        if (bytes != null) {
          // Create a multipart request
          var request = http.MultipartRequest(
            'POST',
            Uri.parse('http://localhost:3000/upload/agri_data_image'),
          );

          // Attach the file as bytes
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: fileName,
          ));

          // Send the request
          var response = await request.send();

          if (response.statusCode == 200) {
            print('File uploaded successfully.');
          } else {
            print('Failed to upload file. Status code: ${response.statusCode}');
          }
        } else {
          print('File content is empty.');
        }
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> uploadAgriSeason() async {
    try {
      // Pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Use bytes property for web
        final bytes = result.files.single.bytes;
        final fileName = result.files.single.name;

        if (bytes != null) {
          // Create a multipart request
          var request = http.MultipartRequest(
            'POST',
            Uri.parse('http://localhost:3000/upload/agri_season'),
          );

          // Attach the file as bytes
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: fileName,
          ));

          // Send the request
          var response = await request.send();

          if (response.statusCode == 200) {
            print('File uploaded successfully.');
          } else {
            print('Failed to upload file. Status code: ${response.statusCode}');
          }
        } else {
          print('File content is empty.');
        }
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> uploadSoilInformation() async {
    try {
      // Pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Use bytes property for web
        final bytes = result.files.single.bytes;
        final fileName = result.files.single.name;

        if (bytes != null) {
          // Create a multipart request
          var request = http.MultipartRequest(
            'POST',
            Uri.parse('http://localhost:3000/upload/agri_soil_information'),
          );

          // Attach the file as bytes
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: fileName,
          ));

          // Send the request
          var response = await request.send();

          if (response.statusCode == 200) {
            print('File uploaded successfully.');
          } else {
            print('Failed to upload file. Status code: ${response.statusCode}');
          }
        } else {
          print('File content is empty.');
        }
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> uploadUserBillofMaterial() async {
    try {
      // Pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Use bytes property for web
        final bytes = result.files.single.bytes;
        final fileName = result.files.single.name;

        if (bytes != null) {
          // Create a multipart request
          var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'http://localhost:3000/upload/agri_user_bill_of_material'),
          );

          // Attach the file as bytes
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: fileName,
          ));

          // Send the request
          var response = await request.send();

          if (response.statusCode == 200) {
            print('File uploaded successfully.');
          } else {
            print('Failed to upload file. Status code: ${response.statusCode}');
          }
        } else {
          print('File content is empty.');
        }
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> uploadUserBOMDetail() async {
    try {
      // Pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Use bytes property for web
        final bytes = result.files.single.bytes;
        final fileName = result.files.single.name;

        if (bytes != null) {
          // Create a multipart request
          var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'http://localhost:3000/upload/agri_user_bill_of_material_detail'),
          );

          // Attach the file as bytes
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: fileName,
          ));

          // Send the request
          var response = await request.send();

          if (response.statusCode == 200) {
            print('File uploaded successfully.');
          } else {
            print('Failed to upload file. Status code: ${response.statusCode}');
          }
        } else {
          print('File content is empty.');
        }
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> uploadUserSoilInformation() async {
    try {
      // Pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Use bytes property for web
        final bytes = result.files.single.bytes;
        final fileName = result.files.single.name;

        if (bytes != null) {
          // Create a multipart request
          var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'http://localhost:3000/upload/agri_user_soil_information'),
          );

          // Attach the file as bytes
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: fileName,
          ));

          // Send the request
          var response = await request.send();

          if (response.statusCode == 200) {
            print('File uploaded successfully.');
          } else {
            print('Failed to upload file. Status code: ${response.statusCode}');
          }
        } else {
          print('File content is empty.');
        }
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> uploadWeatherInformation() async {
    try {
      // Pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Use bytes property for web
        final bytes = result.files.single.bytes;
        final fileName = result.files.single.name;

        if (bytes != null) {
          // Create a multipart request
          var request = http.MultipartRequest(
            'POST',
            Uri.parse('http://localhost:3000/upload/agri_weather_information'),
          );

          // Attach the file as bytes
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: fileName,
          ));

          // Send the request
          var response = await request.send();

          if (response.statusCode == 200) {
            print('File uploaded successfully.');
          } else {
            print('Failed to upload file. Status code: ${response.statusCode}');
          }
        } else {
          print('File content is empty.');
        }
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Excel Files')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: uploadAgriSeason,
                child: const Text("Upload Agri Season Data"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: uploadUserBillofMaterial,
                child: const Text("Upload User Bill of Material"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: uploadUserBOMDetail,
                child: const Text("Upload User BOM Detail"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: uploadSoilInformation,
                child: const Text("Upload Soil Information"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: uploadDataImage,
                child: const Text("Upload Data Image"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: uploadCropBOMDetail,
                child: const Text("Upload Crop BOM Detail"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: uploadCropBillofMaterial,
                child: const Text("Upload Crop Bill of Material"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: uploadUserSoilInformation,
                child: const Text("Upload User Soil Information"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: uploadWeatherInformation,
                child: const Text("Upload Weather Information"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ShowDataTables(tableName: 'agri_season'),
                    ),
                  );
                },
                child: const Text("SHow data of Season"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
