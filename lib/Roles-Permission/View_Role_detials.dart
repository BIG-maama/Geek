import 'package:flutter/material.dart';

class ViewRoleDetails extends StatelessWidget {
  final int userId;
  final String name;
  final List<String> permissions;

  const ViewRoleDetails({
    Key? key,
    required this.userId,
    required this.name,
    required this.permissions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('تفاصيل الدور'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('ID'),
            _buildValueBox(userId.toString()),
            SizedBox(height: 16),

            _buildSectionLabel('Name'),
            _buildValueBox(name),
            SizedBox(height: 24),

            _buildSectionLabel('Permission'),
            ...permissions.map((perm) => _buildPermissionItem(perm)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildValueBox(String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      margin: EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(value, style: TextStyle(fontSize: 16, color: Colors.black87)),
    );
  }

  Widget _buildPermissionItem(String permission) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.check, size: 18, color: Colors.green[700]),
          SizedBox(width: 10),
          Expanded(child: Text(permission, style: TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
