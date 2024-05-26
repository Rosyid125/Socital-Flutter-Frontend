import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socital/widget/my_drawer.dart';
import 'styles.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({Key? key}) : super(key: key);

  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  List<dynamic> _users = [];

  Future<void> _searchUsers(String query) async {
    setState(() {
      _loading = true;
    });

    if (query.isEmpty) {
      return;
    }

    final response = await http
        .get(Uri.parse('http://localhost:8000/api/users/search/$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _users = data['users'];
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data')),
      );
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
          'Search Users',
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search Users',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchUsers(_controller.text);
                  },
                ),
              ),
              onSubmitted: (value) {
                _searchUsers(value);
              },
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        return ListTile(
                          // leading: user['profilepicture'] != null
                          //     ? CircleAvatar(
                          //         backgroundImage:
                          //             NetworkImage(user['profilepicture']),
                          //       )
                          //     : CircleAvatar(
                          //         child: Icon(Icons.person),
                          //       ),
                          title: Text(user['username']),
                          subtitle: Text(
                              'Followers: ${user['followers']} | Followings: ${user['followings']}'),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}
