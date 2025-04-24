import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pro/login_page.dart';
import 'package:pro/widget/constant_url.dart';
import 'package:pro/widget/token.dart';

class king extends StatelessWidget {
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
                    ListTile(
                      leading: Icon(Icons.favorite_border),
                      title: Text("favoites"),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.workspaces_outline),
                      title: Text("workflow"),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.update),
                      title: Text("updates"),
                      onTap: () {},
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.account_tree_outlined),
                      title: Text("plugins"),
                      onTap: () {},
                    ),
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
