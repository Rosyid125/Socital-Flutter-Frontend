import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import Get package
import 'package:socital/routesprotection/ProtectedRoute.dart';

import 'login_screen.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'edit_profile_screen.dart';
import 'search_users.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    return GetMaterialApp(
      // Replace MaterialApp with GetMaterialApp
      debugShowCheckedModeBanner: false,
      // home: FutureBuilder<bool>(
      //   future: _authService.isAuthenticated(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return CircularProgressIndicator(); // Show loading indicator while checking authentication
      //     } else {
      //       if (snapshot.hasData && snapshot.data == true) {
      //         return HomeScreen(); // Navigate to home screen if authenticated
      //       } else {
      //         return LoginScreen(); // Navigate to login screen if not authenticated
      //       }
      //     }
      //   },
      // ),
      initialRoute: '/login', // Set initial route to login
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(
            name: '/register',
            page: () => const RegisterScreen()), // Add GetPage for register
        GetPage(
            name: '/home',
            page: () => const HomeScreen()), // Add GetPage for register
        GetPage(name: '/notifications', page: () => const NotificationScreen()),
        GetPage(name: '/profile/:userid', page: () => const ProfileScreen()),
        GetPage(name: '/updateprofile', page: () => const ProfileEditScreen()),
        GetPage(name: '/searchuser', page: () => const UserSearchPage()),
      ],
    );
  }
}
