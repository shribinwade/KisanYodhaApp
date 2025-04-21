import 'dart:typed_data';
import 'package:blackox/Admin/upload_excel.dart';
import 'package:blackox/Constants/screen_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:blackox/GoogleApi/cloudApi.dart';
import 'package:postgres/postgres.dart'; // Ensure you have your CloudApi class here

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}
class _AdminPanelState extends State<AdminPanel> {
  TextEditingController categoryNameController = TextEditingController();
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);
  Uint8List? _uploadedImageBytes;
  String? _downloadUrl;
  final ImagePicker _picker = ImagePicker();
  CloudApi? cloudApi;
  bool _uploading = false; // Track whether upload is in progress

  @override
  void initState() {
    super.initState();
    _loadCloudApi();
    _requestPermissions();
  }

  Future<void> _loadCloudApi() async {
    String jsonCredentials = await rootBundle.loadString(
        'assets/GoogleJson/clean-emblem-394910-905637ad42b3.json');
    setState(() {
      cloudApi = CloudApi(jsonCredentials);
    });
  }

  Future<void> _requestPermissions() async {
    if (await Permission.photos.request().isGranted) {
      print("Gallery access granted");
    } else {
      print("Gallery access denied");
    }
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future<void> _pickAndUploadImage() async {
    setState(() {
      _uploading = true; // Start uploading, show progress indicator
    });

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file picked')),
      );
      setState(() {
        _uploading = false; // Cancel upload, hide progress indicator
      });
      return;
    }

    if (cloudApi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cloud API not initialized')),
      );
      setState(() {
        _uploading = false; // Cancel upload, hide progress indicator
      });
      return;
    }

    Uint8List imageBytes = await pickedFile.readAsBytes();
    String fileName = pickedFile.name;

    try {
      // Upload the image to the bucket
      final response = await cloudApi!.save(fileName, imageBytes);
      final downloadUrl = await cloudApi!.getDownloadUrl(fileName);
      print(downloadUrl);

      // Store the image bytes to display it
      setState(() {
        _uploadedImageBytes = imageBytes;
        _downloadUrl = downloadUrl;
        _uploading = false; // Upload finished, hide progress indicator
      });
    } catch (e) {
      print("Error uploading image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      setState(() {
        _uploading = false; // Error in upload, hide progress indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const SizedBox(height: 100),
              TextFormField(
                controller: categoryNameController,
                validator: MultiValidator([
                  RequiredValidator(errorText: "Enter Category Name"),
                  MinLengthValidator(3, errorText: 'Minimum 3 character filled name'),
                ]).call,
                decoration: const InputDecoration(
                  hintText: 'Enter Category Name',
                  labelText: 'Enter Category Name',
                  prefixIcon: Icon(Icons.person, color: Colors.green),
                  contentPadding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: ScreenUtility.screenHeight * 0.4,
                width: ScreenUtility.screenWidth * 0.8,
                child: _downloadUrl != null
                    ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.network(_downloadUrl!),
                )
                    : _uploading
                    ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                )
                    : Container(),
              ),
              ElevatedButton(
                onPressed: _uploading ? null : _pickAndUploadImage,
                child: _uploading
                    ? const CircularProgressIndicator() // Show progress indicator
                    : const Text("Upload Icon"),
              ),
              SizedBox(height: ScreenUtility.screenHeight * 0.03),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: currentColor,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Pick a color!'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: pickerColor,
                            onColorChanged: changeColor,
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text('Got it'),
                            onPressed: () {
                              setState(() => currentColor = pickerColor);
                              Navigator.of(context).pop();
                              print(pickerColor);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text("Choose Color"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (categoryNameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Category name cannot be empty')),
                    );
                    return;
                  }
                  bool success = await registerCategory(
                    categoryNameController.text,
                    _downloadUrl ?? '',
                    currentColor.toString(),
                  );
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Category registered successfully')),
                    );
                    // Clear text field and image on success
                    categoryNameController.clear();
                    setState(() {
                      _downloadUrl = null;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to register category')),
                    );
                  }
                },
                child: const Text('Register Category'),
              ),
              ElevatedButton(onPressed: ()
              {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UploadExcel()));
              }, child: const Text("File Upload"))
            ],
          ),
        ),
      ),
    );
  }
  Future<bool> registerCategory(String categoryType, String imageUri, String color) async {
    try {
      final connection = await Connection.open(
        Endpoint(
          host: '34.71.87.187',
          port: 5432,
          database: 'datagovernance',
          username: 'postgres',
          password: 'India@5555',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
      connection.execute(
        'INSERT INTO public.category_master (category_name, image_icon, color) '
            'VALUES (\$1, \$2, \$3)',
        parameters: [categoryType,imageUri,color],
      );
      return true;
    } catch (e) {
      print("Error registering category: $e");
      return false;
    }
  }
}

