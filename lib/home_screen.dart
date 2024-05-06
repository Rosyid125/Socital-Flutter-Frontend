import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socital/styles.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(
          Uri.parse(
              'http://127.0.0.1:8000/api/1/allposts'), // Ganti dengan URL API Anda
          headers: {'Content-Type': 'application/json'});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: AppColors.kindaYellow,
        title: Text(
          'Home',
          style: TextStyles.title,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: posts.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text('Posted by: ${posts[index]['userid']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (posts[index]['post'] != null)
                          Text(posts[index]['post']),
                        if (posts[index]['postpic'] != null)
                          Image.network(
                            posts[index]['postpic'],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        Text('Date: ${posts[index]['datetime']}'),
                        Text('Likes: ${posts[index]['likes']}'),
                        Text('Comments: ${posts[index]['comments']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
