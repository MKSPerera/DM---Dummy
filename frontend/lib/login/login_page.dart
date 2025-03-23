import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/secure_storage_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Login page for the app.
/// Allows users to log in using their contact number and password.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _contactNumberController = TextEditingController(); // Controller for contact number input
  final _passwordController = TextEditingController(); // Controller for password input
  bool _isLoading = false; // Indicates if login is in progress
  String? _errorMessage; // Error message if login fails

  /// Returns the appropriate base URL based on platform
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    return 'http://10.0.2.2:3000';
  }

  /// Handles user login
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/drivers/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'contactNumber': _contactNumberController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Store the token
        await SecureStorageService.storeToken(responseData['token']);

        // Store the driver ID
        await SecureStorageService.storeDriverId(
            responseData['driverId'].toString());

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          _errorMessage = errorData['message'] ?? 'Login failed';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _contactNumberController,
                  decoration: InputDecoration(labelText: 'Contact Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                if (_errorMessage != null)
                  Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child:
                      _isLoading ? CircularProgressIndicator() : Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
