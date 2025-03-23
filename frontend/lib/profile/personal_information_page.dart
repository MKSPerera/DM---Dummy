import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/secure_storage_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  _PersonalInformationPageState createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  bool _isLoading = true;
  Map<String, dynamic> userData = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Get base URL based on platform
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    return 'http://10.0.2.2:3000';
  }

  Future<void> _fetchUserData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final token = await SecureStorageService.getToken();

      if (token == null) {
        setState(() {
          _errorMessage = 'You are not logged in. Please log in again.';
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/drivers/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userData = data;
          _isLoading = false;
        });
        print('User data loaded: $data'); // Debug log to verify data
      } else {
        setState(() {
          _errorMessage = 'Failed to load user data: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDE1FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Personal Information',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchUserData,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection('Basic Information', [
                        _buildInfoItem(
                            'First Name', userData['firstName'] ?? 'N/A'),
                        _buildInfoItem(
                            'Last Name', userData['lastName'] ?? 'N/A'),
                        _buildInfoItem('Email', userData['email'] ?? 'N/A'),
                        _buildInfoItem('Contact Number',
                            userData['contactNumber'] ?? 'N/A'),
                        _buildInfoItem('Address', userData['address'] ?? 'N/A'),
                        _buildInfoItem(
                            'Date of Birth', userData['dateOfBirth'] ?? 'N/A'),
                      ]),
                      const SizedBox(height: 24),
                      _buildInfoSection('License Information', [
                        _buildInfoItem('License Number',
                            userData['licenseNumber'] ?? 'N/A'),
                        _buildInfoItem('License Expiry',
                            userData['licenseExpiry'] ?? 'N/A'),
                      ]),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Add edit functionality here
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Edit functionality coming soon')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD0A9F5),
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Edit Information'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: _fetchUserData,
                          child: const Text('Refresh Data'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.purple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF65469C),
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
