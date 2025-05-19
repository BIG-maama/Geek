import 'dart:convert';
import 'dart:ffi';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pro/Roles-Permission/View_Role_detials.dart';
import 'package:pro/Roles-Permission/permission.dart';
import 'package:pro/widget/constant_url.dart';
import 'package:pro/widget/globalRoles.dart';
// استيراد المتغير

class User_Permission extends StatefulWidget {
  const User_Permission({Key? key}) : super(key: key);

  @override
  State<User_Permission> createState() => _Permission();
}

class _Permission extends State<User_Permission> {
  Future<void> updateRole({
    required int roleId,
    required String updatedName,
    required List<int> updatedPermissionIds,
    required BuildContext context,
  }) async {
    var payload = {"name": updatedName, "permissions": updatedPermissionIds};

    try {
      final response = await http.put(
        Uri.parse("$baseUrl/api/roles/$roleId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
      var result = jsonDecode(response.body);
      if (result["status"] == "success") {
        //  var result = jsonDecode(response.body);
        print("تم التحديث بنجاح: $result");

        // ✅ هنا التصحيح
        List<String> updatedPermissions = List<String>.from(
          result["permissions"],
        );
        final updatedRole = {
          "id": result["role"]["id"],
          "name": result["role"]["name"],
          "permissions": updatedPermissions,
        };

        // تحديث قائمة الأدوار
        globalRoles.removeWhere((role) => role["id"] == result["role"]["id"]);
        globalRoles.add(updatedRole);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => User_Permission(), // تعديل حسب ما يناسبك
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل التعديل: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("حدث خطأ: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("خطأ في الاتصال: $e")));
    }
  }

  Future<void> deleteRole(int id, BuildContext context) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/api/roles/$id"));

      if (response.statusCode == 200) {
        globalRoles.removeWhere((role) => role["id"] == id);

        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'warning!',
            message: 'be careful for what you do ',
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل في الحذف: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("خطأ أثناء الحذف: $e")));
    }
  }

  Future<void> ViewRole(int id, BuildContext context) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/roles/$id"));
      print(response.body);

      var result = jsonDecode(response.body);

      if (result["status"] == "success") {
        final roleData = result["role"];
        int id = roleData["id"];
        String name = roleData["name"];
        List<String> permissions = List<String>.from(roleData["permissions"]);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => ViewRoleDetails(
                  name: name,
                  permissions: permissions,
                  userId: id,
                ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل في الحذف: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("خطأ أثناء الحذف: $e")));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('كل الصلاحيات')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 10,
              children: [
                Text(
                  'إدارة الصلاحيات',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 140),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PermissionsPage(),
                      ),
                    );

                    if (result == true) {
                      setState(() {});
                    }
                  },
                  icon: Icon(Icons.add),
                  label: Text('إضافة'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            ),
            SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,
              itemCount: globalRoles.length,
              itemBuilder: (context, index) {
                final role = globalRoles[index];
                final name = role['name'];
                //final permissions = role['permissions'] as List;

                return Card(
                  //  elevation: 2,
                  child: ListTile(
                    title: Text(name),
                    //   subtitle: Text(permissions.join("، ")),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final roleId = role["id"];
                            final name = role["name"];
                            final permissions = List<int>.from(
                              (role["permissions"] as List).map(
                                (id) => int.parse(id.toString()),
                              ),
                            );

                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PermissionsPage(
                                      roleId: roleId,
                                      initialName: name,
                                      initialPermissionIds: permissions,
                                    ),
                              ),
                            );

                            if (result == true) {
                              setState(() {}); // لتحديث الواجهة بعد التعديل
                            }
                          },
                          icon: Icon(Icons.edit, size: 6, color: Colors.white),
                          label: Text(
                            'تعديل',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final roleId = role["id"];
                            await deleteRole(roleId, context);
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.delete,
                            size: 6,
                            color: Colors.white,
                          ),
                          label: Text(
                            'حذف',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final roleId = role["id"];
                            await ViewRole(roleId, context);
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.remove_red_eye,
                            size: 6,
                            color: Colors.white,
                          ),
                          label: Text(
                            'view',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
