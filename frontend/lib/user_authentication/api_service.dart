import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/secure_storage_service.dart';
import '../services/fcm_service.dart';

/// Handles all authentication-related API requests including:
/// - Driver registration
/// - Driver login
/// - Token management
class ApiService {
  // Base URL for API requests - points to the Android emulator's localhost
  // Different URLs are needed for different environments
  static const String baseUrl = 'http://10.0.2.2:3000'; // For Android emulator
  // static const String baseUrl = 'http://localhost:3000';  // For web
  // static const String baseUrl = 'http://YOUR_IP_ADDRESS:3000';  // For physical device

  /// Registers a new driver with basic information
  /// Returns the response data from the server
  Future<Map<String, dynamic>> register(
      String firstName,
      String lastName,
      String email,
      String password,
      String confirmPassword,
      String contactNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/drivers'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'contactNumber': contactNumber,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  /// Logs in a driver with contact number and password
  /// Returns the response data including authentication token
  Future<Map<String, dynamic>> login(
      String contactNumber, String password) async {
    try {
      print('Attempting login with: $contactNumber'); // Debug log

      final response = await http.post(
        Uri.parse('$baseUrl/drivers/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'contactNumber': contactNumber,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Store the token if it exists in the response
        if (responseData['token'] != null) {
          // You might want to store this token for future authenticated requests
          print('Received token: ${responseData['token']}');
        }
        return responseData;
      } else if (response.body.contains('Driver not found')) {
        await SecureStorageService.handleInvalidToken();
        throw Exception('Invalid credentials or driver not found');
      } else {
        throw Exception(responseData['message'] ?? 'Login failed');
      }
    } catch (e) {
      print('Login error: $e'); // Debug log
      throw Exception('Login failed: $e');
    }
  }

  /// Registers a new driver with complete information including vehicle details
  /// Also includes FCM token for push notifications
  Future<Map<String, dynamic>> registerDriver(
      Map<String, dynamic> driverData) async {
    try {
      // Get FCM token and add to driver data
      final fcmToken = await FCMService.getToken();
      if (fcmToken != null) {
        driverData['fcmToken'] = fcmToken;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/drivers'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(driverData),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Driver registration failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}
