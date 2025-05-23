import 'package:flutter/material.dart';
//import 'package:pro/widget/globalRoles.dart';
import 'package:pro/widget/Global.dart';

class RoleDetailsPage extends StatelessWidget {
  const RoleDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        title: Text('جميع الصلاحيات'),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: globalRoles.length,
        itemBuilder: (context, index) {
          final role = globalRoles[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow("المعرف", role["id"].toString()),
                _buildRow("الاسم", role["name"]),
                const SizedBox(height: 10),
                Text(
                  "الصلاحيات:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: List.generate(
                    role["permissions"].length,
                    (permIndex) => Chip(
                      label: Text(role["permissions"][permIndex]),
                      backgroundColor: Colors.indigo.shade100,
                      labelStyle: TextStyle(color: Colors.indigo[900]),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
