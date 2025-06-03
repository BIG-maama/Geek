import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pro/widget/Global.dart';
import 'package:pro/widget/custom_text.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({Key? key}) : super(key: key);

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;

  Future<void> sendCategoryToApi() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Dio().post(
        "$baseUrl/api/add-category",
        data: {
          "name": nameController.text,
          "description": descriptionController.text,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        AnimatedSnackBar.material(
          response.data['message'],
          type: AnimatedSnackBarType.success,
        ).show(context);
        nameController.clear();
        descriptionController.clear();
      } else {
        AnimatedSnackBar.material(
          "${response.data['message']}",
          type: AnimatedSnackBarType.warning,
        ).show(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: ${e.toString()}')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة فئة جديدة')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(
              label: "name : ",
              controller: nameController,
              keyboardType: TextInputType.name,
              placeholder: "enter a name",
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'الوصف',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: isLoading ? null : sendCategoryToApi,
              icon:
                  isLoading
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Icon(Icons.send),
              label: Text(isLoading ? 'جاري الإرسال...' : 'إرسال'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
