import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pro/widget/Global.dart';

class PermissionsPage extends StatefulWidget {
  final int? roleId;
  final String? initialName;
  final List<int>? initialPermissionIds;

  const PermissionsPage({
    Key? key,
    this.roleId,
    this.initialName,
    this.initialPermissionIds,
  }) : super(key: key);

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  late TextEditingController nameController;
  Map<int, String> permissionIdToName = {};
  Map<String, bool> selectedPermissions = {};
  bool isLoading = true;
  String error = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    ShowAllPermission();
    nameController = TextEditingController(text: widget.initialName ?? '');
    userName = widget.initialName ?? '';
    //  StoreNewRole();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
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
            for (var entry in data.entries)
              entry.value:
                  widget.initialPermissionIds?.contains(int.parse(entry.key)) ??
                  false,
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
      http.Response response;

      if (widget.roleId != null) {
        response = await http.put(
          Uri.parse("$baseUrl/api/roles/${widget.roleId}"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(payload),
        );
      } else {
        response = await http.post(
          Uri.parse("$baseUrl/api/roles"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(payload),
        );
      }

      var result = jsonDecode(response.body);

      if (result["status"] == "success") {
        Map<String, dynamic> roleData = result["role"];
        Map<String, dynamic> formattedRole = {
          "name": roleData["name"],
          "id": roleData["id"],
          "permissions": List<String>.from(roleData["permissions"]),
        };
        globalRoles.removeWhere((role) => role["id"] == roleData["id"]);
        globalRoles.add(formattedRole);

        Navigator.pop(context, true);

        Future.delayed(Duration(milliseconds: 300), () {
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
        });
      } else if (result["status"] == "sucseess") {
        Map<String, dynamic> roleData = result["role"];
        print("gg");
        Map<String, dynamic> formattedRole = {
          "name": roleData["name"],
          "id": roleData["id"],
          "permissions": List<String>.from(result["permissions"]),
        };
        print("3ds");
        globalRoles.removeWhere((role) => role["id"] == roleData["id"]);
        globalRoles.add(formattedRole);

        Navigator.pop(context, true); // <-- الرجوع إلى صفحة User_Permission

        // بعد الرجوع، انتظر ثم أظهر SnackBar
        Future.delayed(Duration(milliseconds: 300), () {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'تحديث!',
              message: 'تم تنفيذ العملية بنجاح تام 🎉',
              contentType: ContentType.success,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    } catch (e) {
      print("فشل العملية: $e");
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
                          controller: nameController,
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
                    },
                    child: const Text("send permission"),
                  ),
                ],
              ),
    );
  }
}
