import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pro/BottomNavigator/Medicines/create_category.dart';
import 'package:pro/BottomNavigator/Medicines/medic_&_catg_info.dart';

class Medicines_Category_page extends StatefulWidget {
  const Medicines_Category_page({Key? key}) : super(key: key);

  @override
  State<Medicines_Category_page> createState() => _Medicines();
}

class _Medicines extends State<Medicines_Category_page> {
  late Box<CategoryInfo> categoryBox;

  @override
  void initState() {
    super.initState();
    categoryBox = Hive.box<CategoryInfo>('categorys');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('فئات الأدوية')),
      body: ValueListenableBuilder(
        valueListenable: categoryBox.listenable(),
        builder: (context, Box<CategoryInfo> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('لا توجد فئات مضافة بعد.'));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final item = box.getAt(index);
              return Card(
                margin: const EdgeInsets.all(12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    item?.name ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(item?.description ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => box.deleteAt(index),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCategoryPage()),
          );
        },
        label: const Text("إضافة فئة جديدة"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
