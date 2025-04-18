import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const home());
}

class home extends StatefulWidget {
  const home({super.key});
  @override
  State<home> createState() => _home();
}

class _home extends State<home> {
  Future<List> getdata() async {
    var response = await get(
      Uri.parse("https://jsonplaceholder.typicode.com/posts"),
    );
    List responsebody = jsonDecode(response.body);
    return responsebody;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List>(
        future: getdata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              return ListTile(
                title: Text("${snapshot.data![i]['title']}"),
                leading: Text("${snapshot.data![i]['id']}"),
              );
            },
          );
        },
      ),
    );
  }
}
