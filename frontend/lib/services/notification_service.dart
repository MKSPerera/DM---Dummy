import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/secure_storage_service.dart';

/// Handles all notification-related functionality including:
/// - Setting up Firebase Cloud Messaging (FCM) handlers
/// - Fetching notifications from the backend API
/// - Marking notifications as read
class NotificationService {
  // Base URL for API requests - points to the Android emulator's localhost
  static const String baseUrl = 'http://10.0.2.2:3000';

  /// Sets up all Firebase Cloud Messaging handlers for different app states:
  /// - Foreground: When app is open and visible
  /// - Background: When app is open but not in focus
  /// - Terminated: When app is completely closed
  static Future<void> setupNotificationHandlers() async {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // You can display a local notification here if needed
      }
    });

    // Set up background/terminated message handlers
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Check if app was opened from a notification when terminated
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print(
            'App opened from terminated state by notification: ${message.data}');
        // Navigate to relevant screen based on notification data
      }
    });

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'App opened from background state by notification: ${message.data}');
      // Navigate to relevant screen based on notification data
    });
  }

  /// Background message handler - must be top-level function
  /// This is called when a message is received while the app is in the background
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  /// Fetches notifications from the backend API
  /// Returns a list of notification objects
  /// Throws an exception if the request fails
  static Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      // Get authentication token from secure storage
      final token = await SecureStorageService.getToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Make API request to get notifications
      final response = await http.get(
        Uri.parse('$baseUrl/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> notificationsJson = json.decode(response.body);
        return notificationsJson.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting notifications: $e');
      throw Exception('Failed to load notifications: $e');
    }
  }

  /// Marks a notification as read in the backend
  /// Takes a notification ID as parameter
  /// Throws an exception if the request fails
  static Future<void> markAsRead(int notificationId) async {
    try {
      // Get authentication token from secure storage
      final token = await SecureStorageService.getToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Make API request to mark notification as read
      final response = await http.post(
        Uri.parse('$baseUrl/notifications/read/$notificationId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to mark notification as read: ${response.statusCode}');
      }
    } catch (e) {
      print('Error marking notification as read: $e');
      throw Exception('Failed to mark notification as read: $e');
    }
  }
}
