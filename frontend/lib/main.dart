import 'package:flutter/material.dart';
import 'homepage+job_board/homepage.dart';
import 'calendar/calendar_page.dart';
import 'user_authentication/signin_page.dart';
import 'user_authentication/signup_page.dart';
import 'user_authentication/welcome_page.dart';
import 'user_authentication/vehicle_info_page.dart';
import 'profile/profile.dart';
import 'profile/personal_information_page.dart'; // Add this import
import 'profile/vehicle_information_profile.dart'; // Add this import
import 'splash_screen.dart'; // Add this import
import 'profile/accepted_completed_jobs_page.dart';
import 'profile/status_performance_page.dart';
import 'profile/legal_terms_page.dart';
import 'profile/settings_page.dart';
import 'notifications/notifications_page.dart';
import 'ongoing_jobs/ongoing_jobs_page.dart';
import 'services/fcm_service.dart';
import 'services/notification_service.dart';
// Import other pages as needed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FCMService.initialize();
  await NotificationService.setupNotificationHandlers();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash', // Change initial route to splash screen
      routes: {
        '/splash': (context) => const SplashScreen(), // Add splash screen route
        '/': (context) => const WelcomePage(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignupPage(),
        '/vehicle-info': (context) => const VehicleInfoPage(),
        '/home': (context) => const HomePage(),
        '/calendar': (context) => const CalendarPage(),
        '/profile': (context) => const ProfileScreen(), // Add this route
        '/personal-info': (context) =>
            const PersonalInformationPage(), // Add this route
        '/vehicle-information-profile': (context) => const VehicleInformationProfile(), // Add this route
        '/accepted-completed-jobs': (context) => const AcceptedCompletedJobsPage(),
        '/status-performance': (context) => const StatusPerformancePage(),
        '/legal-terms': (context) => const LegalTermsPage(),
        '/settings': (context) => const SettingsPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/ongoing-jobs': (context) => const OngoingJobsPage(),
        // Add other routes as needed
      },
    );
  }
}
