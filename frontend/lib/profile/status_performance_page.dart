import 'package:flutter/material.dart';

class StatusPerformancePage extends StatelessWidget {
  const StatusPerformancePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample performance data
    final performanceData = {
      'rating': 4.8,
      'totalJobs': 42,
      'completedJobs': 40,
      'cancelledJobs': 2,
      'onTimePercentage': 95,
      'status': 'Active',
      'memberSince': '2023-01-15',
    };

    return Scaffold(
      backgroundColor: const Color(0xFFEDE1FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Status & Performance',
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
            // Rating Card
            Container(
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
                children: [
                  const Text(
                    'Your Rating',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF65469C),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        performanceData['rating'].toString(),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF65469C),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStarRating(performanceData['rating'] as double),
                          Text(
                            'out of 5',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Job Statistics
            _buildInfoSection('Job Statistics', [
              _buildInfoItem('Total Jobs', performanceData['totalJobs'].toString()),
              _buildInfoItem('Completed Jobs', performanceData['completedJobs'].toString()),
              _buildInfoItem('Cancelled Jobs', performanceData['cancelledJobs'].toString()),
              _buildInfoItem('On-Time Percentage', '${performanceData['onTimePercentage']}%'),
            ]),
            
            const SizedBox(height: 24),
            
            // Account Status
            _buildInfoSection('Account Status', [
              _buildInfoItem('Status', performanceData['status'] as String),
              _buildInfoItem('Member Since', performanceData['memberSince'] as String),
            ]),
            
            const SizedBox(height: 24),
            
            // Performance Tips
            Container(
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
                children: const [
                  Text(
                    'Tips to Improve Your Performance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF65469C),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '• Arrive on time for all pickups\n'
                    '• Keep your vehicle clean and well-maintained\n'
                    '• Communicate professionally with clients\n'
                    '• Follow all traffic rules and drive safely\n'
                    '• Complete jobs as described in the job details',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : (index < rating) 
                  ? Icons.star_half
                  : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
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
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 