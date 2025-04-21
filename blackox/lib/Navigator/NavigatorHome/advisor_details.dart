import 'package:blackox/Services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:blackox/Model/Advisor_details.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvisorDetailsScreen extends StatefulWidget {
  const AdvisorDetailsScreen({super.key});

  @override
  State<AdvisorDetailsScreen> createState() => _AdvisorDetailsScreenState();
}

class _AdvisorDetailsScreenState extends State<AdvisorDetailsScreen> {
  final DatabaseService databaseService = DatabaseService();
  final TextEditingController _searchController = TextEditingController();
  final String _searchQuery = '';
  List<AdvisorDetails> _advisorDetails = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchAdvisorDetails();
  }

  Future<void> _fetchAdvisorDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final advisorDetails = await databaseService.getALlAdvisorDetails();
      setState(() {
        _advisorDetails = advisorDetails;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error fetching advisor details: $e';
        _isLoading = false;
      });
      print('Error fetching advisor details: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advisor Community'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : ListView.builder(
                  itemCount: _advisorDetails.length,
                  itemBuilder: (context, index) {
                    final advisor = _advisorDetails[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: ListTile(
                                    leading: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          advisor.imageURL,
                                          width: 34,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        )
                                      ],
                                    ),
                                    title: Text(
                                      advisor.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          advisor.email,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          '${advisor.city}, ${advisor.state}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.phone_outlined,
                                        size: 28,
                                      ),
                                      onPressed: () {
                                        _showPhoneNumber(
                                            context, advisor.mobile ?? '');
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.public,
                                        size: 28,
                                      ),
                                      onPressed: () async {
                                        final Uri url =
                                            Uri.parse(advisor.website);
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url);
                                        } else {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Could not launch website'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showPhoneNumber(BuildContext context, String phoneNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Contact Number",
            style: TextStyle(fontSize: 20),
          ),
          content: Text(
            phoneNumber,
            style: const TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              child: const Text(
                "Call",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onPressed: () async {
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: phoneNumber,
                );
                await launchUrl(launchUri);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
