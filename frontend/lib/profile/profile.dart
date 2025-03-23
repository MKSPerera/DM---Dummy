import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../nav_bar/nav_bar.dart';
import '../services/secure_storage_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'personal_information_page.dart';
import 'vehicle_information_profile.dart';
import 'accepted_completed_jobs_page.dart';
import 'status_performance_page.dart';
import 'legal_terms_page.dart';
import 'settings_page.dart';

/// Profile screen that displays driver information and provides
/// access to various profile-related sections:
/// - Personal information
/// - Vehicle information
/// - Job history
/// - Performance metrics
/// - Settings
/// - Legal terms
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _selectedTabIndex = 3; // Set to 3 for Profile tab
  bool _isLoading = true;
  Map<String, dynamic> userData = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  /// Returns the appropriate base URL based on platform
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    return 'http://10.0.2.2:3000';
  }

  /// Fetches user profile data from the API
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

  /// Handles navigation when bottom nav bar items are tapped
  void _onNavBarItemTapped(int index) {
    if (index == _selectedTabIndex) {
      return; // Don't navigate if already on the page
    }

    switch (index) {
      case 0: // Home
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1: // Calendar
        Navigator.pushReplacementNamed(context, '/calendar');
        break;
      case 2: // Ongoing Jobs
        Navigator.pushReplacementNamed(context, '/ongoing-jobs');
        break;
      case 3: // Profile - already on profile page
        break;
    }
  }

  Widget _buildProfileOption({
    required String title,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFD0A9F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDE1FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
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
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Profile Image and Name
                        Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.purple[700]!, width: 2),
                              ),
                              child: Center(
                                child: Icon(Icons.person_outline,
                                    size: 50, color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              // Display the driver's full name instead of "Driver Name"
                              '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              // Display the driver's email
                              userData['email'] ?? 'No email available',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                        // Profile Options in Container with margin and border
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.purple.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildProfileOption(
                                title: 'Personal Information',
                                icon: Icons.person_outline,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PersonalInformationPage(),
                                    ),
                                  );
                                },
                              ),
                              _buildProfileOption(
                                title: 'Vehicle Information',
                                icon: Icons.directions_car_outlined,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const VehicleInformationProfile(),
                                    ),
                                  );
                                },
                              ),
                              _buildProfileOption(
                                title: 'Accepted and Completed Jobs',
                                icon: Icons.work_outline,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AcceptedCompletedJobsPage(),
                                    ),
                                  );
                                },
                              ),
                              _buildProfileOption(
                                title: 'Status and Performance',
                                icon: Icons.analytics_outlined,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const StatusPerformancePage(),
                                    ),
                                  );
                                },
                              ),
                              _buildProfileOption(
                                title: 'Legal and Terms',
                                icon: Icons.description_outlined,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const LegalTermsPage(),
                                    ),
                                  );
                                },
                              ),
                              _buildProfileOption(
                                title: 'Settings',
                                icon: Icons.settings_outlined,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SettingsPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32), // Increased spacing
                        // Add Logout Button
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Logout'),
                                  content:
                                      Text('Are you sure you want to logout?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // Clear the stored token and driver ID
                                        await SecureStorageService
                                            .deleteToken();
                                        await SecureStorageService
                                            .deleteDriverId();

                                        // Navigate to welcome page and clear navigation stack
                                        if (context.mounted) {
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/',
                                            (route) => false,
                                          );
                                        }
                                      },
                                      child: Text('Logout'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red[400],
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation:
                                2, // Added slight elevation for better visibility
                          ),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20), // Bottom padding
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedTabIndex,
        onItemTapped: _onNavBarItemTapped,
      ),
    );
  }
}
