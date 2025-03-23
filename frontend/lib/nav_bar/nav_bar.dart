import 'package:flutter/material.dart';

/// Custom navigation bar used throughout the app.
/// Allows navigation between Home, Calendar, Ongoing Jobs, and Profile.
class CustomNavBar extends StatefulWidget {
  final Function(int) onItemTapped; // Callback for item tap
  final int selectedIndex; // Currently selected index

  const CustomNavBar({super.key, required this.onItemTapped, required this.selectedIndex});

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple[100], // Light purple background
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        currentIndex: widget.selectedIndex,
        onTap: widget.onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            label: 'Ongoing Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
