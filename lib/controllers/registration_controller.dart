import 'dart:convert';

import 'package:socital/utils/api_endpoints.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class RegistrationController extends GetxController {
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String confpassword,
  }) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.register);

      Map<String, String> body = {
        'username': username,
        'email': email.trim(),
        'password': password,
        'confpassword': confpassword,
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        Get.offNamed('/login');
      } else {
        var message = "Unknown error occurred";
        print(message);
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
