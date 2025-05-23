import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pro/widget/Global.dart';

class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  // List<Map<String, dynamic>> users = [];

  final _formKey = GlobalKey<FormState>();
  String selectedRole = globalRoles.isNotEmpty ? globalRoles[0]["name"] : "";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String gender = "male";
  String role = "user";

  Future<void> submitUser() async {
    final uri = Uri.parse('$baseUrl/api/users');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": nameController.text,
          "email": emailController.text,
          "phone": phoneController.text,
          "password": passwordController.text,
          "gender": gender,
          "roles": [selectedRole],
        }),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = result["user"];
        final newUser = {
          "id": userData["id"],
          "name": userData["name"],
          "email": userData["email"],
          "phone": userData["phone"],
          "gender": userData["gender"],
          "roles": List<Map<String, dynamic>>.from(userData["roles"]),
        };

        setState(() {
          createUser.add(newUser);
        });
        print(createUser);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ تم إنشاء المستخدم بنجاح")),
        );
      } else {
        print("فشل: ${result['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ فشل إنشاء المستخدم: ${result['message']}")),
        );
      }
    } catch (e) {
      print("خطأ أثناء الإرسال: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("حدث خطأ أثناء الاتصال بالخادم.")),
      );
    }
  }

  void _showCreateUserDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("create new user"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(nameController, 'name'),
                  _buildTextField(emailController, 'gmail'),
                  _buildTextField(
                    passwordController,
                    'password',
                    isPassword: true,
                  ),
                  _buildTextField(phoneController, 'phone number'),
                  const SizedBox(height: 10),
                  _buildDropdown("gender", ["male", "female"], gender, (val) {
                    setState(() => gender = val!);
                  }),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    "roles",
                    globalRoles.map((role) => role["name"].toString()).toList(),
                    selectedRole,
                    (val) => setState(() => selectedRole = val!),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  submitUser();
                }
              },
              child: const Text("حفظ"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator:
            (value) =>
                value == null || value.isEmpty ? 'هذا الحقل مطلوب' : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String selected,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: selected,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items:
          items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _deleteUser(int userId) async {
    final uri = Uri.parse('$baseUrl/api/users/$userId');

    try {
      final response = await http.delete(uri);
      print(response);
      if (response.statusCode == 200 || response.statusCode == 204) {
        // إزالة المستخدم من القائمة وتحديث الواجهة
        setState(() {
          createUser.removeWhere((user) => user["id"] == userId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ تم حذف المستخدم بنجاح")),
        );
      } else {
        print("فشل الحذف: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ فشل حذف المستخدم: ${response.body}")),
        );
      }
    } catch (e) {
      print("خطأ أثناء الحذف: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ حدث خطأ أثناء الاتصال بالخادم")),
      );
    }
  }

  Future<void> showOneUser(int id) async {
    final String url = '$baseUrl/api/users/$id';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["status"] == "success") {
          viewUserDetails.add(data["data"]);
          print(viewUserDetails);
        } else {
          print("خطأ في الاستجابة: ${data["message"]}");
        }
      } else {
        print("فشل في الاتصال: ${response.statusCode}");
      }
    } catch (e) {
      print("حدث خطأ: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إدارة المستخدمين')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateUserDialog,
        icon: Icon(Icons.person_add),
        label: Text("Add User"),
      ),
      body:
          createUser.isEmpty
              ? Center(child: Text("لا يوجد مستخدمين بعد"))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: createUser.length,
                itemBuilder: (context, index) {
                  final user = createUser[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.indigo.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow("الاسم", user["name"]),
                        _buildRow("البريد", user["email"]),
                        _buildRow("الهاتف", user["phone"]),
                        _buildRow("الجنس", user["gender"]),
                        _buildRow(
                          "الدور",
                          user["roles"].map((r) => r["name"]).join(", "),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _editUser(user);
                              } else if (value == 'delete') {
                                _deleteUser(user["id"]);
                              } else if (value == 'show') {
                                showOneUser(user["id"]);
                              }
                            },
                            itemBuilder:
                                (BuildContext context) => [
                                  PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, color: Colors.blue),
                                        SizedBox(width: 8),
                                        Text('تعديل'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('حذف'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'show',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.remove_red_eye_sharp,
                                          color: Colors.greenAccent,
                                        ),
                                        SizedBox(width: 8),
                                        Text('مشاهدة'),
                                      ],
                                    ),
                                  ),
                                ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}

Widget _buildRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text("$label: ", style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
      ],
    ),
  );
}

void _editUser(Map<String, dynamic> user) {
  // يمكنك إظهار Dialog هنا وتعديل القيم
  print("تعديل المستخدم ${user["id"]}");
}
