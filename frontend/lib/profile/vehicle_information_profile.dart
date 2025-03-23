import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/secure_storage_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class VehicleInformationProfile extends StatefulWidget {
  const VehicleInformationProfile({super.key});

  @override
  _VehicleInformationProfileState createState() =>
      _VehicleInformationProfileState();
}

class _VehicleInformationProfileState extends State<VehicleInformationProfile> {
  bool _isLoading = true;
  Map<String, dynamic> vehicleData = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchVehicleData();
  }

  // Get base URL based on platform
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    return 'http://10.0.2.2:3000';
  }

  Future<void> _fetchVehicleData() async {
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
          // Extract vehicle data from the profile response
          vehicleData = {
            'vehicleType': data['vehicleType'],
            'vehicleModel': data['vehicleModel'],
            'vehicleYear': data['vehicleYear'],
            'vehicleColor': data['vehicleColor'],
            'licensePlate': data['licensePlate'],
            'vehicleCapacity': data['vehicleCapacity']?.toString(),
            'registrationNumber': data['registrationNumber'],
            'registrationExpiry': data['registrationExpiry'],
            'insuranceProvider': data['insuranceProvider'],
            'insuranceNumber': data['insuranceNumber'],
            'insuranceExpiry': data['insuranceExpiry'],
          };
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load vehicle data: ${response.statusCode}';
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
          'Vehicle Information',
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
                        onPressed: _fetchVehicleData,
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
                      _buildInfoSection('Vehicle Details', [
                        _buildInfoItem('Vehicle Type',
                            vehicleData['vehicleType'] ?? 'N/A'),
                        _buildInfoItem('Vehicle Model',
                            vehicleData['vehicleModel'] ?? 'N/A'),
                        _buildInfoItem(
                            'Year', vehicleData['vehicleYear'] ?? 'N/A'),
                        _buildInfoItem(
                            'Color', vehicleData['vehicleColor'] ?? 'N/A'),
                        _buildInfoItem('License Plate',
                            vehicleData['licensePlate'] ?? 'N/A'),
                        _buildInfoItem('Capacity',
                            vehicleData['vehicleCapacity'] ?? 'N/A'),
                      ]),
                      const SizedBox(height: 24),
                      _buildInfoSection('Registration Information', [
                        _buildInfoItem('Registration Number',
                            vehicleData['registrationNumber'] ?? 'N/A'),
                        _buildInfoItem('Registration Expiry',
                            vehicleData['registrationExpiry'] ?? 'N/A'),
                      ]),
                      const SizedBox(height: 24),
                      _buildInfoSection('Insurance Information', [
                        _buildInfoItem('Insurance Provider',
                            vehicleData['insuranceProvider'] ?? 'N/A'),
                        _buildInfoItem('Insurance Number',
                            vehicleData['insuranceNumber'] ?? 'N/A'),
                        _buildInfoItem('Insurance Expiry',
                            vehicleData['insuranceExpiry'] ?? 'N/A'),
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
                          child: const Text('Edit Vehicle Information'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: _fetchVehicleData,
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
            width: 140,
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
