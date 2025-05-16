import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pro/Roles-Permission/user_permission.dart';
import 'dart:convert';
import 'package:pro/widget/constant_url.dart';
import 'package:pro/widget/globalRoles.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({Key? key}) : super(key: key);

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  Map<int, String> permissionIdToName = {};
  Map<String, bool> selectedPermissions = {};
  bool isLoading = true;
  String error = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    ShowAllPermission();
  }

  Future<void> ShowAllPermission() async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/api/show-all-permissions"),
      );
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
        Map<String, dynamic> data = jsonResponse['data'];

        setState(() {
          permissionIdToName = {
            for (var entry in data.entries) int.parse(entry.key): entry.value,
          };

          selectedPermissions = {
            for (var entry in data.entries) entry.value: false,
          };

          isLoading = false;
        });
      } else {
        setState(() {
          error = "البيانات غير متوفرة";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "فشل الاتصال: $e";
        isLoading = false;
      });
    }
  }

  Future<void> StoreNewRole() async {
    List<int> selectedIds =
        permissionIdToName.entries
            .where((entry) => selectedPermissions[entry.value] == true)
            .map((entry) => entry.key)
            .toList();

    var payload = {"name": userName, "permissions": selectedIds};

    try {
      var response = await http.post(
        Uri.parse("$baseUrl/api/roles"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      var result = jsonDecode(response.body);

      if (result["status"] == "success") {
        Map<String, dynamic> roleData = result["role"];

        Map<String, dynamic> formattedRole = {
          "name": roleData["name"],
          "id": roleData["id"],
          "permissions": List<String>.from(roleData["permissions"]),
        };

        globalRoles.add(formattedRole); // حفظ الدور الجديد في القائمة
        print(globalRoles);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => User_Permission(), // بدون تمرير roles
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("فشل في إنشاء الدور")));
      }
    } catch (e) {
      print("فشل الإرسال: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("فشل الإرسال")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الصلاحيات")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : error.isNotEmpty
              ? Center(child: Text(error))
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      const Text('name :'),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'enter a Name',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) => userName = val,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ...selectedPermissions.entries.map((entry) {
                    return CheckboxListTile(
                      title: Text(entry.key),
                      value: entry.value,
                      onChanged: (val) {
                        setState(() {
                          selectedPermissions[entry.key] = val!;
                        });
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      StoreNewRole();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => User_Permission(),
                        ),
                      );
                    },
                    child: const Text("send permission"),
                  ),
                ],
              ),
    );
  }
}
