import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pro/Permission/View_Role_detials.dart';
import 'package:pro/Permission/all_role&permission.dart';
import 'package:pro/Permission/permission.dart';
import 'package:pro/widget/Global.dart';

class User_Permission extends StatefulWidget {
  const User_Permission({Key? key}) : super(key: key);

  @override
  State<User_Permission> createState() => _Permission();
}

class _Permission extends State<User_Permission> {
  Future<void> deleteRole(int id, BuildContext context) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/api/roles/$id"));

      if (response.statusCode == 200) {
        globalRoles.removeWhere((role) => role["id"] == id);
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

  Future<void> fetchAllRoles() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/roles"));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final roles = json['data'];

        globalRoles.clear(); // تفريغ القديم
        for (var role in roles) {
          globalRoles.add({
            "id": role["id"],
            "name": role["name"],
            "permissions": List<String>.from(role["permissions"]),
          });
        }
      } else {
        print("فشل في جلب البيانات: ${response.statusCode}");
      }
    } catch (e) {
      print("خطأ أثناء جلب البيانات: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllRoles().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('كل الصلاحيات'),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'All roles and permission',
                  child: ListTile(
                    leading: Icon(Icons.accessibility_new_sharp),
                    title: Text('roles & permission'),
                  ),
                ),
              ];
            },
            onSelected: (String value) async {
              if (value == 'All roles and permission') {
                await fetchAllRoles();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RoleDetailsPage()),
                );
              }
            },
          ),
        ],
      ),

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
                          iconAlignment: IconAlignment.end,
                          onPressed: () async {
                            final roleId = role['id'];
                            final name = role['name'];
                            final permissionNames = List<String>.from(
                              role['permissions'],
                            );

                            print("$permissionNames");
                            final response = await http.get(
                              Uri.parse("$baseUrl/api/show-all-permissions"),
                            );
                            final data = jsonDecode(response.body);

                            if (data["status"] != "success") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("فشل في تحميل الصلاحيات"),
                                ),
                              );
                              return;
                            }

                            final Map<String, int> permissionNameToId = {
                              for (var entry in data["data"].entries)
                                entry.value.trim(): int.parse(entry.key),
                            };

                            // 3. حوّل الأسماء إلى معرفات
                            final permissions =
                                permissionNames
                                    .map(
                                      (name) => permissionNameToId[name.trim()],
                                    )
                                    .whereType<int>()
                                    .toList();

                            // 4. انتقل إلى صفحة PermissionsPage
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
                              setState(() {}); // تحديث الواجهة
                            }
                          },
                          icon: Icon(Icons.edit, size: 10, color: Colors.white),
                          label: Text(
                            '',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                          ),
                        ),
                        ElevatedButton.icon(
                          iconAlignment: IconAlignment.end,
                          onPressed: () async {
                            final roleId = role["id"];
                            await deleteRole(roleId, context);
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.delete,
                            size: 10,
                            color: Colors.white,
                          ),
                          label: Text(
                            '',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                        ElevatedButton.icon(
                          iconAlignment: IconAlignment.end,
                          onPressed: () async {
                            final roleId = role["id"];
                            await ViewRole(roleId, context);
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.remove_red_eye,
                            size: 10,
                            color: Colors.white,
                          ),
                          label: Text(
                            "",
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
