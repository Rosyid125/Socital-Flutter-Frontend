import 'package:flutter/material.dart';
import 'package:socital/styles.dart';
import 'package:socital/widget/custom_texfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socital/widget/my_drawer.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _prevPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _editProfile() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String bio = _bioController.text;
    String prevPassword = _prevPasswordController.text;
    String newPassword = _newPasswordController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      setState(() {
        _errorMessage = "No auth token found";
      });
      return;
    }

    final response = await http.post(
      Uri.parse('http://localhost:8000/api/users/edit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'bio': bio,
        'prevpassword': prevPassword,
        'newpassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      // Handle successful response
      setState(() {
        _errorMessage = "Profile updated successfully";
      });
    } else {
      // Handle error response
      setState(() {
        _errorMessage =
            "Failed to update profile on some fields (e.g. email or password)";
      });
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              CustomTextfield(
                controller: _usernameController,
                textInputType: TextInputType.name,
                textInputAction: TextInputAction.next,
                hint: 'Username',
                invisible: false,
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomTextfield(
                controller: _emailController,
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                hint: 'Email',
                invisible: false,
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomTextfield(
                controller: _bioController,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
                hint: 'Bio',
                invisible: false,
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomTextfield(
                controller: _prevPasswordController,
                textInputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                hint: 'Previous Password',
                invisible: true,
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomTextfield(
                controller: _newPasswordController,
                textInputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                hint: 'New Password',
                invisible: true,
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                  onPressed: _editProfile, child: Text('Save Changes')),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}
