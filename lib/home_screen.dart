import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socital/styles.dart';
import 'package:socital/widget/my_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> posts = [];
  int? _userid;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userid = prefs.getInt('userid');

      setState(() {
        _userid = userid;
      });

      final response = await http.get(
        Uri.parse(
            'http://127.0.0.1:8000/api/users/$userid/allposts'), // Ganti dengan URL API Anda
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
            builder: (context) => const HomeScreen(),
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

  // Future<void> likePost(int postId) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //   try {
  //     final response = await http.post(
  //         Uri.parse(
  //             'http://127.0.0.1:8000/api/posts/$postId/likes/like'), // Ganti dengan URL API Anda
  //         headers: {'Authorization': 'Bearer $token'});
  //     if (response.statusCode == 200) {
  //       fetchPosts();
  //       // setState(() {
  //       //   _likeId = json.decode(response.body)['likeid'];
  //       // });
  //     } else {
  //       throw Exception('Failed to like');
  //     }
  //   } catch (error) {
  //     print(error.toString());
  //     // Handle error
  //   }
  // }

  // Future<void> unlikePost(int postId, likeId) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //   try {
  //     final response = await http.post(
  //         Uri.parse(
  //             'http://127.0.0.1:8000/api/posts/$postId/likes/$likeId'), // Ganti dengan URL API Anda
  //         headers: {'Authorization': 'Bearer $token'});
  //     if (response.statusCode == 200) {
  //       fetchPosts();
  //     } else {
  //       throw Exception('Failed unlike');
  //     }
  //   } catch (error) {
  //     print(error.toString());
  //     // Handle error
  //   }
  // }

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewPostScreen(),
            ),
          );
        },
        child: const Icon(Icons.post_add),
      ),
    );
  }
}

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final uri = Uri.parse('http://localhost:8000/api/posts/create');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'content': _contentController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        //reload page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        throw Exception('Failed to create new post');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create a New Post',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitPost,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Submit Post'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
