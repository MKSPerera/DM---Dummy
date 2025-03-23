import 'package:flutter/material.dart';
import 'job_board.dart'; // Import the separated job board file
import 'job_details.dart'; // Add this import
import '../nav_bar/nav_bar.dart';

/// Main homepage of the app.
/// Displays a search bar and integrates the job board.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedNavIndex = 0; // Index for the selected navigation item
  int _jobBoardTabIndex = 0; // Index for the selected job board tab

  /// Handles navigation bar item taps
  void _onNavBarItemTapped(int index) {
    if (index == _selectedNavIndex) {
      return; // Don't navigate if already on the page
    }

    setState(() {
      _selectedNavIndex = index; // Update selected index
    });

    // Navigate to the selected page
    switch (index) {
      case 0: // Home - already on home page
        break;
      case 1: // Calendar
        Navigator.pushReplacementNamed(context, '/calendar');
        break;
      case 2: // Ongoing Jobs
        Navigator.pushReplacementNamed(context, '/ongoing-jobs');
        break;
      case 3: // Profile
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDE1FF), // Light purple background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Home',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 30),
            child: IconButton(
              icon: Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for jobs...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Upcoming Jobs Section - NEW SECTION
            Text(
              'Upcoming Jobs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  // Navigate to job details page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailsPage(
                        job: {
                          'jobId': 'upcoming-1',
                          'title': 'Airport Pickup',
                          'description':
                              'Pick up client from JFK Airport Terminal 4 and drop off at Manhattan Hotel.',
                          'location': 'JFK Airport, Queens, NY',
                          'destination': 'Hilton Hotel, Manhattan, NY',
                          'date': '2023-11-25',
                          'time': '14:30',
                          'price': '65',
                          'status': 'accepted',
                          'clientName': 'Michael Johnson',
                          'clientPhone': '+1 (555) 123-4567',
                          'distance': '18 miles',
                          'estimatedDuration': '45 minutes',
                        },
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFFD0A9F5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.directions_car,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Airport Pickup',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'JFK Airport → Manhattan',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Colors.black54,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Nov 25, 2:30 PM',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.attach_money,
                                  size: 14,
                                  color: Colors.black54,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '\$65',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF65469C).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'In 3 days',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF65469C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Rewards and Perks Section
            Container(
              height: 120,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rewards and Perks',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        6,
                        (index) => Container(
                          width: 100,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Icon(Icons.card_giftcard,
                                size: 40, color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 16),
            // Job Board Section
            Expanded(
              child: JobBoard(
                onTabChanged: (index) {
                  setState(() {
                    _jobBoardTabIndex = index;
                  });
                },
                selectedTabIndex: _jobBoardTabIndex,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedNavIndex,
        onItemTapped: _onNavBarItemTapped,
      ),
    );
  }
}
