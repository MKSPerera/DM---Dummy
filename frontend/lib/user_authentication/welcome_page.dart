// welcome_page.dart
import 'package:flutter/material.dart';
import '../services/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    try {
      // Retrieve token from secure storage
      final token = await SecureStorageService.getToken();

      if (token != null) {
        // Validate token by making a request to the backend
        final response = await http.get(
          Uri.parse('${ApiService.baseUrl}/drivers/validate-token'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 401 ||
            response.body.contains('Driver not found')) {
          // Token is invalid or driver not found
          await SecureStorageService.handleInvalidToken();
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        } else if (response.statusCode == 200) {
          // Token is valid
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      } else {
        // No token, show welcome page
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      // Handle any errors by showing welcome page
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD0A9F5),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF65469C)))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      color: Color(0xFF65469C),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signin');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF65469C),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF65469C),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
    );
  }
}
