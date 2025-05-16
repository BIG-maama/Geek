import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  // Future<void> DeleteRole() async {
  //   var response = await http.put(Uri.parse("$baseUrl/api/roles/3"));
  // }

  Future<void> deleteRole(int id, BuildContext context) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/api/roles/$id"));

      if (response.statusCode == 200) {
        globalRoles.removeWhere((role) => role["id"] == id);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("تم حذف الدور بنجاح")));
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PermissionsPage(),
                      ),
                    );
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
              //   physics: NeverScrollableScrollPhysics(),
              itemCount: globalRoles.length,
              itemBuilder: (context, index) {
                final role = globalRoles[index];
                final name = role['name'];
                //  final permissions = role['permissions'] as List;

                return Card(
                  child: ListTile(
                    title: Text(name),
                    //subtitle: Text(permissions.join("، ")),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
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
