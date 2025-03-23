import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../services/secure_storage_service.dart';

/// Handles all job-related API requests including:
/// - Fetching available jobs
/// - Fetching driver's accepted jobs
/// - Accepting and rejecting jobs
/// - Managing busy dates
class JobService {
  /// Returns the appropriate base URL based on platform
  /// - Web: localhost
  /// - Android emulator: 10.0.2.2 (special IP that routes to host machine)
  /// - Physical device: would need actual IP address
  static String get baseUrl {
    // If running on web, use localhost
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    // If running on Android emulator, use 10.0.2.2
    // If running on physical device, use your computer's IP address
    return 'http://10.0.2.2:3000';
  }

  /// Prepares authentication headers for API requests
  /// Includes Content-Type, Accept, and Authorization if token exists
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await SecureStorageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Fetches all available jobs from the API
  /// Returns a list of job objects
  Future<List<Map<String, dynamic>>> getJobs() async {
    try {
      final headers = await _getAuthHeaders();
      print('Fetching jobs from: $baseUrl/jobs'); // Debug print
      print('Headers: ${headers.toString()}'); // Debug auth headers

      final response = await http.get(
        Uri.parse('$baseUrl/jobs'),
        headers: headers,
      );

      print('Response status: ${response.statusCode}'); // Debug print

      // Only print body if not empty to avoid errors
      if (response.body.isNotEmpty) {
        print('Response body: ${response.body}'); // Debug print
      } else {
        print('Response body is empty');
      }

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          // Handle empty response
          return [];
        }

        List<dynamic> jobsJson = json.decode(response.body);
        return jobsJson.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 401 ||
          response.body.contains('Driver not found')) {
        // Handle invalid token
        await SecureStorageService.handleInvalidToken();
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 500) {
        // Handle server error
        print('Server error 500 received');
        throw Exception('Server error: Please try again later');
      } else {
        // Try to decode error body if possible
        try {
          final errorBody = json.decode(response.body);
          throw Exception(errorBody['message'] ?? 'Failed to load jobs');
        } catch (decodeError) {
          throw Exception('Failed to load jobs: Status ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error in getJobs: $e'); // Detailed error logging
      if (e is FormatException) {
        throw Exception('Invalid response format from server');
      } else if (e is http.ClientException) {
        throw Exception(
            'Connection error: Please check your internet connection');
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Fetches jobs assigned to the current driver
  /// Returns a list of job objects
  Future<List<Map<String, dynamic>>> getMyJobs() async {
    try {
      final headers = await _getAuthHeaders();
      print('Fetching my jobs from: $baseUrl/jobs/my-jobs'); // Debug print
      print('Headers: ${headers.toString()}'); // Debug auth headers

      final response = await http.get(
        Uri.parse('$baseUrl/jobs/my-jobs'),
        headers: headers,
      );

      print('Response status: ${response.statusCode}'); // Debug print

      // Only print body if not empty to avoid errors
      if (response.body.isNotEmpty) {
        print('Response body: ${response.body}'); // Debug print
      } else {
        print('Response body is empty');
      }

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          // Handle empty response
          return [];
        }

        List<dynamic> jobsJson = json.decode(response.body);
        return jobsJson.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 401) {
        throw Exception('Please login again');
      } else if (response.statusCode == 500) {
        // Handle server error
        print('Server error 500 received');
        throw Exception('Server error: Please try again later');
      } else {
        // Try to decode error body if possible
        try {
          final errorBody = json.decode(response.body);
          throw Exception(errorBody['message'] ?? 'Failed to load jobs');
        } catch (decodeError) {
          throw Exception('Failed to load jobs: Status ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error in getMyJobs: $e'); // Detailed error logging
      if (e is FormatException) {
        throw Exception('Invalid response format from server');
      } else if (e is http.ClientException) {
        throw Exception(
            'Connection error: Please check your internet connection');
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> acceptJob(int jobId) async {
    try {
      print('JobService: Starting acceptJob with jobId: $jobId'); // Log start

      final headers = await _getAuthHeaders();
      print(
          'JobService: Headers prepared: ${headers.toString()}'); // Log headers

      print(
          'JobService: Making POST request to $baseUrl/jobs/accept'); // Log URL
      final response = await http.post(
        Uri.parse('$baseUrl/jobs/accept'),
        headers: headers,
        body: json.encode({
          'jobId': jobId,
        }),
      );

      print(
          'JobService: Response status: ${response.statusCode}'); // Log status
      print('JobService: Response body: ${response.body}'); // Log response

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('JobService: Successfully decoded response data'); // Log success
        return responseData['data']['job'];
      } else if (response.statusCode == 401) {
        print(
            'JobService: Unauthorized - token may be invalid'); // Log auth error
        throw Exception('Unauthorized - Please login again');
      } else {
        final errorData = json.decode(response.body);
        print(
            'JobService: Error data: ${errorData.toString()}'); // Log error data
        throw Exception(errorData['message'] ?? 'Failed to accept job');
      }
    } catch (e, stackTrace) {
      // Added stackTrace
      print('JobService Error: $e'); // Log error
      print('JobService Stack trace: $stackTrace'); // Log stack trace
      throw Exception('Failed to accept job: $e');
    }
  }

  // Get driver's calendar availability
  Future<List<Map<String, dynamic>>> getDriverAvailability() async {
    try {
      final headers = await _getAuthHeaders();

      // TEMPORARY FIX: Use the updated endpoint that doesn't require driverId in the URL
      final response = await http.get(
        Uri.parse('$baseUrl/calendar'),
        headers: headers,
      );

      print('Response status: ${response.statusCode}');

      if (response.body.isNotEmpty) {
        print('Response body: ${response.body}');
      } else {
        print('Response body is empty');
      }

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return [];
        }

        List<dynamic> availabilityJson = json.decode(response.body);
        return availabilityJson.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 401) {
        throw Exception('Please login again');
      } else {
        throw Exception(
            'Failed to load availability: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getDriverAvailability: $e');
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<void> addBusyDate(DateTime startDate, DateTime endDate) async {
    try {
      final headers = await _getAuthHeaders();

      // Ensure dates are at the start of the day and properly formatted
      final formattedStartDate =
          DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0)
              .toUtc()
              .toIso8601String();

      final formattedEndDate =
          DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59)
              .toUtc()
              .toIso8601String();

      final response = await http.post(
        Uri.parse('$baseUrl/calendar/busy-dates'),
        headers: headers,
        body: json.encode({
          'startDate': formattedStartDate,
          'endDate': formattedEndDate,
        }),
      );

      if (response.statusCode != 201) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to add busy date');
      }
    } catch (e) {
      print('Error in addBusyDate: $e');
      throw Exception('Failed to add busy date: $e');
    }
  }

  Future<void> deleteBusyDate(int availabilityId) async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http.delete(
        Uri.parse('$baseUrl/calendar/busy-dates/$availabilityId'),
        headers: headers,
      );

      print('Delete response status: ${response.statusCode}');
      print('Delete response body: ${response.body}');

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Busy date not found');
      } else if (response.statusCode == 403) {
        throw Exception('You can only delete your own busy dates');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to delete busy date');
      }
    } catch (e) {
      print('Error in deleteBusyDate: $e');
      if (e is FormatException) {
        throw Exception('Invalid response from server');
      }
      throw Exception('Failed to delete busy date: $e');
    }
  }

  Future<Map<String, dynamic>> rejectJob(int jobId, {String? rejectionReason}) async {
    try {
      print('JobService: Starting rejectJob with jobId: $jobId'); // Log start

      final headers = await _getAuthHeaders();
      print('JobService: Headers prepared: ${headers.toString()}'); // Log headers

      print('JobService: Making POST request to $baseUrl/jobs/reject'); // Log URL
      final response = await http.post(
        Uri.parse('$baseUrl/jobs/reject'),
        headers: headers,
        body: json.encode({
          'jobId': jobId,
          'rejectionReason': rejectionReason,
        }),
      );

      print('JobService: Response status: ${response.statusCode}'); // Log status
      print('JobService: Response body: ${response.body}'); // Log response

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('JobService: Successfully decoded response data'); // Log success
        return responseData['data']['job'];
      } else if (response.statusCode == 401) {
        print('JobService: Unauthorized - token may be invalid'); // Log auth error
        throw Exception('Unauthorized - Please login again');
      } else {
        final errorData = json.decode(response.body);
        print('JobService: Error data: ${errorData.toString()}'); // Log error data
        throw Exception(errorData['message'] ?? 'Failed to reject job');
      }
    } catch (e, stackTrace) {
      print('JobService Error: $e'); // Log error
      print('JobService Stack trace: $stackTrace'); // Log stack trace
      throw Exception('Failed to reject job: $e');
    }
  }

  // Add a method to fetch a specific job by ID
  Future<Map<String, dynamic>> getJobById(String jobId) async {
    try {
      final headers = await _getAuthHeaders();
      
      print('Fetching job details for ID: $jobId'); // Debug print
      
      final response = await http.get(
        Uri.parse('$baseUrl/jobs/$jobId'),
        headers: headers,
      );
      
      print('Response status: ${response.statusCode}'); // Debug print
      
      if (response.body.isNotEmpty) {
        print('Response body: ${response.body}'); // Debug print
      }
      
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('Job not found');
        }
        
        final jobData = json.decode(response.body);
        return jobData;
      } else if (response.statusCode == 401) {
        // Handle invalid token
        await SecureStorageService.handleInvalidToken();
        throw Exception('Session expired. Please login again.');
      } else {
        // Try to decode error body if possible
        try {
          final errorBody = json.decode(response.body);
          throw Exception(errorBody['message'] ?? 'Failed to load job details');
        } catch (decodeError) {
          throw Exception('Failed to load job details: Status ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error fetching job details: $e');
      throw Exception('Failed to load job details: $e');
    }
  }
}
