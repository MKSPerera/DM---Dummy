import 'package:flutter/material.dart';

class AcceptedCompletedJobsPage extends StatefulWidget {
  const AcceptedCompletedJobsPage({super.key});

  @override
  _AcceptedCompletedJobsPageState createState() => _AcceptedCompletedJobsPageState();
}

class _AcceptedCompletedJobsPageState extends State<AcceptedCompletedJobsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Sample job data - in a real app, you would fetch this from your backend
  final List<Map<String, dynamic>> acceptedJobs = [
    {
      'title': 'Airport Pickup',
      'date': '2023-10-15',
      'time': '14:30',
      'location': 'JFK Airport',
      'payment': '45',
      'status': 'accepted',
    },
    {
      'title': 'Corporate Event Transport',
      'date': '2023-10-20',
      'time': '09:00',
      'location': 'Downtown Convention Center',
      'payment': '60',
      'status': 'accepted',
    },
  ];
  
  final List<Map<String, dynamic>> completedJobs = [
    {
      'title': 'Wedding Transport',
      'date': '2023-09-25',
      'time': '16:00',
      'location': 'Grand Plaza Hotel',
      'payment': '75',
      'status': 'completed',
      'completedDate': '2023-09-25',
    },
    {
      'title': 'City Tour',
      'date': '2023-09-18',
      'time': '10:00',
      'location': 'Central Park',
      'payment': '55',
      'status': 'completed',
      'completedDate': '2023-09-18',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE1FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My Jobs',
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF65469C),
          labelColor: Colors.black,
          tabs: const [
            Tab(text: 'Accepted'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildJobList(acceptedJobs, 'accepted'),
          _buildJobList(completedJobs, 'completed'),
        ],
      ),
    );
  }

  Widget _buildJobList(List<Map<String, dynamic>> jobs, String type) {
    if (jobs.isEmpty) {
      return Center(
        child: Text(
          'No $type jobs found',
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.purple.withOpacity(0.3), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job['title'] ?? 'Untitled Job',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF65469C),
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoItem('Date', job['date']),
                _buildInfoItem('Time', job['time']),
                _buildInfoItem('Location', job['location']),
                _buildInfoItem('Payment', '\$${job['payment']}'),
                _buildInfoItem('Status', job['status']),
                if (type == 'completed')
                  _buildInfoItem('Completed On', job['completedDate']),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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