import 'package:flutter/material.dart';
import 'package:pro/BottomNavigator/Medicines/create_category.dart';

class Medicines_page extends StatefulWidget {
  const Medicines_page({Key? key}) : super(key: key);

  @override
  State<Medicines_page> createState() => _Medicines();
}

class _Medicines extends State<Medicines_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأدوية')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text("إضافة فئة جديدة"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddCategoryPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
