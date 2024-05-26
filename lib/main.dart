// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socital/routesprotection/AuthMiddleware.dart';
import 'package:socital/routesprotection/ProtectedRoute.dart';
import 'package:socital/login_screen.dart';
import 'package:socital/register_screen.dart';
import 'package:socital/home_screen.dart';
import 'package:socital/notifications_screen.dart';
import 'package:socital/profile_screen.dart';
import 'package:socital/edit_profile_screen.dart';
import 'package:socital/search_users.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(
          name: '/home',
          page: () => const HomeScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/notifications',
          page: () => const NotificationScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/profile/:userid',
          page: () => const ProfileScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/updateprofile',
          page: () => const ProfileEditScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/searchuser',
          page: () => const UserSearchPage(),
          middlewares: [AuthMiddleware()],
        ),
      ],
    );
  }
}
