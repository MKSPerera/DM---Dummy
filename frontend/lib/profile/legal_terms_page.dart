import 'package:flutter/material.dart';

class LegalTermsPage extends StatelessWidget {
  const LegalTermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE1FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Legal & Terms',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Terms of Service',
              'Last updated: September 30, 2023',
              _termsOfServiceText,
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Privacy Policy',
              'Last updated: September 30, 2023',
              _privacyPolicyText,
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Driver Agreement',
              'Last updated: September 30, 2023',
              _driverAgreementText,
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Show acceptance dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Terms accepted. Thank you!'),
                      backgroundColor: Color(0xFF65469C),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF65469C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Accept Terms & Conditions'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String lastUpdated, String content) {
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
          const SizedBox(height: 4),
          Text(
            lastUpdated,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Sample text content
  static const String _termsOfServiceText = 
    'These Terms of Service ("Terms") govern your access to and use of the Drive Mate application ("App"), website, and services. By accessing or using the App, you agree to be bound by these Terms.\n\n'
    '1. Eligibility: You must be at least 18 years old and possess a valid driver\'s license to use our services as a driver.\n\n'
    '2. Account Registration: You agree to provide accurate information during registration and to keep your account information updated.\n\n'
    '3. Driver Responsibilities: As a driver, you are responsible for maintaining your vehicle in good condition, having valid insurance, and complying with all applicable laws and regulations.';

  static const String _privacyPolicyText = 
    'This Privacy Policy describes how Drive Mate collects, uses, and shares your personal information when you use our App and services.\n\n'
    '1. Information We Collect: We collect information you provide during registration, including your name, contact information, driver\'s license details, vehicle information, and payment details.\n\n'
    '2. How We Use Your Information: We use your information to provide our services, process payments, communicate with you, and improve our App.\n\n'
    '3. Information Sharing: We may share your information with job posters, payment processors, and as required by law.';

  static const String _driverAgreementText = 
    'This Driver Agreement ("Agreement") is between you and Drive Mate.\n\n'
    '1. Independent Contractor Status: You acknowledge that you are an independent contractor and not an employee of Drive Mate.\n\n'
    '2. Service Standards: You agree to provide professional, courteous service to all clients and to maintain high standards of conduct.\n\n'
    '3. Vehicle Requirements: You are responsible for ensuring your vehicle meets all safety and regulatory requirements.';
} 