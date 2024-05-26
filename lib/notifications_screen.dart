import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socital/styles.dart';
import 'package:socital/widget/my_drawer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:8000/api/notifications/5'), // Update the URL to your API endpoint
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          notifications = json.decode(response.body)['notifications'];
        });
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (error) {
      print(error.toString());
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: AppColors.kindaYellow,
        title: const Text(
          'Notifications',
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: notifications.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(notifications[index]['notification']),
                    subtitle: Text('Date: ${notifications[index]['datetime']}'),
                    // trailing: notifications[index]['status'] == 'unread'
                    //     ? Icon(Icons.circle, color: Colors.red, size: 12)
                    //     : null,
                  ),
                );
              },
            ),
      drawer: const MyDrawer(),
    );
  }
}
