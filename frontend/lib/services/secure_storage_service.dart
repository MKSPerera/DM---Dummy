import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Provides secure storage functionality for sensitive data like:
/// - JWT authentication tokens
/// - Driver ID
/// 
/// Uses Flutter Secure Storage which leverages platform-specific
/// encryption mechanisms (Keystore on Android, Keychain on iOS)
class SecureStorageService {
  // Instance of FlutterSecureStorage
  static const _storage = FlutterSecureStorage();
  
  // Keys for storing different types of data
  static const _tokenKey = 'jwt_token';
  static const _driverIdKey = 'driver_id';

  /// Stores JWT token securely
  static Future<void> storeToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Retrieves JWT token from secure storage
  /// Returns null if no token is found
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Deletes JWT token from secure storage
  /// Used during logout or when token is invalid
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Stores driver ID securely
  static Future<void> storeDriverId(String driverId) async {
    await _storage.write(key: _driverIdKey, value: driverId);
  }

  /// Retrieves driver ID from secure storage
  /// Returns null if no driver ID is found
  static Future<String?> getDriverId() async {
    return await _storage.read(key: _driverIdKey);
  }

  /// Deletes driver ID from secure storage
  /// Used during logout
  static Future<void> deleteDriverId() async {
    await _storage.delete(key: _driverIdKey);
  }

  /// Helper function to handle invalid token scenarios
  /// Clears both token and driver ID from storage
  /// Called when API returns 401 Unauthorized
  static Future<void> handleInvalidToken() async {
    await deleteToken();
    await deleteDriverId();
  }
}
