import 'package:flutter/material.dart';
import 'package:pro/widget/Global.dart';

class UserSuccessView extends StatelessWidget {
  const UserSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = viewUserDetails.isNotEmpty ? viewUserDetails[0] : {};
    final roles = user["roles"] as List<dynamic>? ?? [];
    final roleNames = roles.map((role) => role["name"]).join(", ");

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text('بيانات المستخدم'),
        ),
        body:
            viewUserDetails.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.verified_user_rounded,
                        size: 70,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user["name"] ?? "غير معروف",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _infoBox(
                        label: "الاسم",
                        value: user["name"] ?? "غير متوفر",
                      ),
                      _infoBox(
                        label: "البريد الإلكتروني",
                        value: user["email"] ?? "غير متوفر",
                      ),
                      _infoBox(
                        label: "رقم الهاتف",
                        value: user["phone"] ?? "غير متوفر",
                      ),
                      _infoBox(
                        label: "الجنس",
                        value:
                            user["gender"] == "male"
                                ? "ذكر"
                                : user["gender"] == "female"
                                ? "أنثى"
                                : "غير محدد",
                      ),
                      _infoBox(
                        label: "الدور",
                        value: roleNames.isNotEmpty ? roleNames : "بدون دور",
                      ),
                      _infoBox(
                        label: "تاريخ الإنشاء",
                        value:
                            user["created_at"]?.toString().substring(0, 10) ??
                            "غير متوفر",
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // // مثال: فتح صفحة المستخدم في API
                          // final id = user["id"];
                          // if (id != null) {
                          //   final url = "http://localhost:8000/api/users/$id";
                          //   // يمكنك استخدام url_launcher مثلاً
                          // }
                        },
                        child: const Text(
                          "عرض المزيد",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _infoBox({required String label, required String value}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.indigo.shade100),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
