import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import Get package
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socital/styles.dart';
import 'package:socital/widget/my_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<dynamic> posts = [];

  @override
  void initState() {
    super.initState();
    final userid = int.parse(
        Get.parameters['userid']!); // Get the userid from route parameters
    fetchPosts(userid);
  }

  Future<void> fetchPosts(int userid) async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/users/$userid/posts'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          posts = json.decode(response.body)['posts'];
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (error) {
      print(error.toString());
      // Handle error
    }
  }

  Future<void> deletePost(int postId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/posts/$postId/delete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          posts.removeWhere((post) => post['postid'] == postId);
        });
      } else {
        throw Exception('Failed to delete post');
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
          'Home',
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: posts.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListTile(
                              title: Text(
                                  'Posted by: ${posts[index]['user']['username']}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (posts[index]['content'] != null)
                                    Text(posts[index]['content']),
                                  if (posts[index]['postpicture'] != null)
                                    Image.network(
                                      posts[index]['postpicture'],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  Text('Date: ${posts[index]['datetime']}'),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.thumb_up),
                                  onPressed: () {
                                    // Implement like functionality here
                                  },
                                ),
                                Text(
                                  '${posts[index]['likes']}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.comment),
                                  onPressed: () {
                                    // Implement comment functionality here
                                  },
                                ),
                                Text(
                                  '${posts[index]['comments']}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deletePost(posts[index]['postid']);
                            // Implement delete functionality
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      drawer: const MyDrawer(),
    );
  }
}
