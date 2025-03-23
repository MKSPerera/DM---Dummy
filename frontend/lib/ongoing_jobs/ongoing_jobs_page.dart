import 'package:flutter/material.dart';
import '../nav_bar/nav_bar.dart';
import '../homepage+job_board/job_details.dart';

class OngoingJobsPage extends StatefulWidget {
  const OngoingJobsPage({super.key});

  @override
  _OngoingJobsPageState createState() => _OngoingJobsPageState();
}

class _OngoingJobsPageState extends State<OngoingJobsPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> ongoingJobs = [];
  String? errorMessage;
  int _selectedNavIndex = 2; // Ongoing Jobs tab is selected

  @override
  void initState() {
    super.initState();
    _loadOngoingJobs();
  }

  Future<void> _loadOngoingJobs() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // In a real app, you would fetch ongoing jobs from your backend
      // For now, we'll use sample data
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

      // Sample data
      final sampleJobs = [
        {
          'jobId': 'job-001',
          'title': 'Airport Pickup',
          'description': 'Pick up client from JFK Airport Terminal 4 and drop off at Manhattan Hotel.',
          'location': 'JFK Airport, Queens, NY',
          'destination': 'Hilton Hotel, Manhattan, NY',
          'date': '2023-11-25',
          'time': '14:30',
          'price': '65',
          'status': 'in_progress',
          'progress': 0.4, // 40% complete
          'clientName': 'Michael Johnson',
          'clientPhone': '+1 (555) 123-4567',
          'distance': '18 miles',
          'estimatedDuration': '45 minutes',
          'startTime': '2023-11-25 14:30',
          'estimatedEndTime': '2023-11-25 15:15',
        },
        {
          'jobId': 'job-002',
          'title': 'Corporate Event Transportation',
          'description': 'Provide transportation for executives attending corporate event.',
          'location': 'Marriott Hotel, Brooklyn, NY',
          'destination': 'Convention Center, Manhattan, NY',
          'date': '2023-11-26',
          'time': '09:00',
          'price': '120',
          'status': 'in_progress',
          'progress': 0.7, // 70% complete
          'clientName': 'Sarah Williams',
          'clientPhone': '+1 (555) 987-6543',
          'distance': '12 miles',
          'estimatedDuration': '35 minutes',
          'startTime': '2023-11-26 09:00',
          'estimatedEndTime': '2023-11-26 09:35',
        },
      ];

      setState(() {
        ongoingJobs = sampleJobs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load ongoing jobs: ${e.toString()}';
      });
    }
  }

  void _onNavBarItemTapped(int index) {
    if (index == _selectedNavIndex) {
      return; // Don't navigate if already on the page
    }

    setState(() {
      _selectedNavIndex = index;
    });

    switch (index) {
      case 0: // Home
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1: // Calendar
        Navigator.pushReplacementNamed(context, '/calendar');
        break;
      case 2: // Ongoing Jobs - already on this page
        break;
      case 3: // Profile
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE1FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Ongoing Jobs',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _loadOngoingJobs,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : ongoingJobs.isEmpty
                    ? const Center(child: Text('No ongoing jobs'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: ongoingJobs.length,
                        itemBuilder: (context, index) {
                          final job = ongoingJobs[index];
                          return _buildOngoingJobCard(job);
                        },
                      ),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedNavIndex,
        onItemTapped: _onNavBarItemTapped,
      ),
    );
  }

  Widget _buildOngoingJobCard(Map<String, dynamic> job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobDetailsPage(job: job),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      job['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF65469C).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'In Progress',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF65469C),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                job['description'],
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              // Progress indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress: ${(job['progress'] * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'ETA: ${job['estimatedEndTime'].toString().split(' ')[1].substring(0, 5)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: job['progress'],
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF65469C)),
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 10,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Location and destination
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'From: ${job['location']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.flag_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'To: ${job['destination']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to navigation/maps app
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Opening navigation...'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.directions, size: 16),
                      label: const Text('Navigate'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF65469C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Call client
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Calling client...'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.phone, size: 16),
                      label: const Text('Call Client'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF65469C),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Color(0xFF65469C)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 