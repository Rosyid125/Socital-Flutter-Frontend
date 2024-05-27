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
  Map<String, dynamic> user = {};
  int? _userid;

  @override
  void initState() {
    super.initState();
    final userid = int.parse(
        Get.parameters['userid']!); // Get the userid from route parameters
    fetchPosts(userid);
    fetchUserInfo(userid); // Fetch user info when the screen initializes
  }

  Future<void> fetchUserInfo(int userid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final currentuserid = prefs.getInt('userid');
    setState(() {
      _userid = currentuserid;
    });
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/users/$userid'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          user = json.decode(response.body)['user'][0];
        });
      } else {
        throw Exception('Failed to load user information');
      }
    } catch (error) {
      print(error.toString());
      // Handle error
    }
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
          Uri.parse(
              'http://127.0.0.1:8000/api/posts/$postId/delete'), // Ganti dengan URL API Anda
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        Navigator.pop(context);
        //reload page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      } else {
        throw Exception('Failed to create new post');
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
          'User Profile',
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: posts.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                user.isEmpty
                    ? const CircularProgressIndicator()
                    : userCard(user),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  padding: EdgeInsets.all(16.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/profile/${posts[index]['userid']}',
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundImage: NetworkImage(
                                                  posts[index]['user']
                                                      ['profilepicture']),
                                            ),
                                            SizedBox(width: 16.0),
                                            Text(
                                              '${posts[index]['user']['username']}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.0),
                                        if (posts[index]['content'] != null)
                                          Text(
                                            posts[index]['content'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        if (posts[index]['postpicture'] != null)
                                          SizedBox(
                                            height: 200,
                                            child: Image.network(
                                              posts[index]['postpicture'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          '${posts[index]['datetime']}',
                                          style: TextStyle(
                                            color: AppColors.kindaBlue,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '${posts[index]['likes']} Likes',
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      '${posts[index]['comments']} Comments',
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (posts[index]['user']['userid'] == _userid)
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
              ],
            ),
      drawer: const MyDrawer(),
    );
  }

  Widget userCard(Map<String, dynamic> user) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            user['profilepicture'] != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(user['profilepicture']),
                  )
                : CircleAvatar(
                    child: Icon(Icons.person),
                  ),
            const SizedBox(height: 16.0),
            Text(
              user['username'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              user['email'],
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(user['bio']),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      '${user['followers']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Followers'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${user['followings']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Followings'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
