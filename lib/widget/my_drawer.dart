import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socital/styles.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

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
              Get.toNamed('/profile');
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
              // Tambahkan logika logout di sini
            },
          ),
        ],
      ),
    );
  }
}
