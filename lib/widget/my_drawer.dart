import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socital/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int? userid;

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  Future<void> fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('userid');
    setState(() {
      userid = id;
    });
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences
        .getInstance(); // Ini sayanga bisa saya lakukan cuman menghapus dari sharedprefs, lasoalnya kan cors errror, sedih padahal sudah buat auth middleware
    await prefs.remove('userid');
    await prefs.remove('token');
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 55, // Adjust the height as needed
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.kindaYellow,
            ),
            child: const Align(
              alignment: Alignment.center,
              child: Text(
                'Socital',
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Get.toNamed('/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {
              Get.toNamed('/notifications');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              if (userid != null) {
                Get.toNamed('/profile/$userid');
              } else {
                // Handle the case where userid is null if necessary
                print('User ID not found');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Profile'),
            onTap: () {
              Get.toNamed('/updateprofile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search Users'),
            onTap: () {
              Get.toNamed('/searchuser');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Add logout logic here
              logout();
            },
          ),
        ],
      ),
    );
  }
}
