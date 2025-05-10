import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pro/first/login_page.dart';
import 'package:pro/widget/constant_url.dart';
import 'package:pro/widget/profile.dart';
import 'package:pro/widget/token.dart';

class king extends StatefulWidget {
  const king({Key? key}) : super(key: key);
  @override
  State<king> createState() => _king();
}

class _king extends State<king> {
  Future<void> logout(BuildContext context) async {
    final token = await tokenManager.getToken();

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/api/logout-user'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'نجاح!',
              message: 'تم تنفيذ العملية بنجاح تام 🎉',
              contentType: ContentType.success,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.green.shade100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "name : ${UserData.currentUser!.name}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "email : ${UserData.currentUser!.email}",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "phone : ${UserData.currentUser!.phone}",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "gender : ${UserData.currentUser!.gender}",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "created_at : ${UserData.currentUser!.date}",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(29),
                child: Wrap(
                  runSpacing: 15,
                  children: [
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text("home"),
                      onTap: () {},
                    ),

                    Divider(),

                    ListTile(
                      leading: Icon(Icons.logout_outlined),
                      title: Text("log out"),
                      onTap: () {
                        logout(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(child: Text(" whatsapp my back-end")),
    );
  }
}
