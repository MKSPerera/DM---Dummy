import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../firebase_options.dart';

/// Background message handler for Firebase Cloud Messaging
/// Must be a top-level function (not a class method)
/// This is called when a message is received while the app is in the background
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Need to ensure Firebase is initialized here too
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
}

/// Manages Firebase Cloud Messaging (FCM) functionality:
/// - Initializing Firebase
/// - Requesting notification permissions
/// - Getting and refreshing FCM tokens
class FCMService {
  // Firebase Messaging instance
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  // Cached FCM token
  static String? _fcmToken;

  /// Initializes Firebase and requests notification permissions
  /// Sets up background message handler and token refresh listener
  static Future<void> initialize() async {
    try {
      // Initialize Firebase with platform-specific options
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      // Set the background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      
      // Request permission for notifications
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted notification permission');
      } else {
        print('User declined or has not accepted notification permission');
      }
      
      // Get the token
      await getToken();
      
      // Listen for token refreshes
      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        _fcmToken = token;
        print('FCM Token refreshed: $_fcmToken');
        // TODO: Update token on the server
      });
      
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  /// Gets the FCM token for the device
  /// Returns the token as a string, or null if there was an error
  static Future<String?> getToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      print('FCM Token: $_fcmToken');
      return _fcmToken;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }
} 