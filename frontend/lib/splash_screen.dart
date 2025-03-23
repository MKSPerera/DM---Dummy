import 'package:flutter/material.dart';
import 'dart:async';
import 'services/secure_storage_service.dart';

/// Splash screen displayed when the app starts
/// Shows the app logo and name while checking authentication status
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to the appropriate screen after a delay
    Timer(const Duration(seconds: 5), () {
      _checkAuthAndNavigate();
    });
  }

  /// Checks if user is authenticated and navigates accordingly
  /// - If token exists, navigate to home screen
  /// - If no token, navigate to welcome screen
  Future<void> _checkAuthAndNavigate() async {
    final token = await SecureStorageService.getToken();

    if (!mounted) return;

    if (token != null) {
      // User is logged in, navigate to home
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // User is not logged in, navigate to welcome page
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDE1FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -40), // Increased negative offset to -40
              child: SizedBox(
                width: 200,
                child: const Text(
                  'Drive Mate',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF65469C),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
