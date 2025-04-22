import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pro/login_page.dart';
import 'package:pro/widget/token.dart';

class king extends StatelessWidget {
  Future<void> logout(BuildContext context) async {
    final token = await tokenManager.getToken();

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.1.105:8000/api/logout-user'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          print("Logout successful");
        } else {
          print("Logout failed: ${response.statusCode}");
        }
      } catch (e) {
        print("Error during logout: $e");
      }
    }

    await tokenManager.clearToken();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("hello")),
      drawer: Drawer(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: IconButton(
              onPressed: () {
                logout(context);
              },
              icon: Icon(Icons.settings_power_outlined),
            ),
          ),
        ),
      ),
      body: Center(child: Text(" whatsapp my back-end")),
    );
  }
}
