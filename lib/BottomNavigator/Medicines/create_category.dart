import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:pro/BottomNavigator/Medicines/medic_&_catg_info.dart';
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
  final TextEditingController MedFormName = TextEditingController();
  final TextEditingController MedFormDesc = TextEditingController();
  bool isLoading = false;
  List<dynamic> items = [];

  Future<void> deleteItem(int id) async {
    try {
      final response = await Dio().delete("$baseUrl/api/medicine-forms/$id");
      if (response.statusCode == 200 || response.statusCode == 204) {
        Fluttertoast.showToast(
          msg: "تم الحذف بنجاح",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
        );
      }
    } catch (e) {
      print("فشل الحذف: $e");
      Fluttertoast.showToast(
        msg: "فشل الحذف",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> getCategoryInfo() async {
    try {
      final response = await Dio().get("$baseUrl/api/medicine-forms");

      if (response.statusCode == 200) {
        final responseData = response.data;
        final List<dynamic> allItems = responseData['data'];

        if (allItems.isNotEmpty) {
          setState(() {
            items = List.from(allItems); // ✅ تحديث القائمة
          });
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setStateDialog) {
                  return AlertDialog(
                    title: const Text('جميع الأشكال الدوائية'),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xFFE0E0E0),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'الاسم: ${item['name']}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'الوصف: ${item['description']}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: CupertinoColors.systemGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        await deleteItem(item['id']);
                                        setState(() {
                                          items.removeAt(index);
                                        });
                                        setStateDialog(() {});
                                      },
                                      child: const Icon(
                                        CupertinoIcons.delete_solid,
                                        color: CupertinoColors.systemRed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إغلاق'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        } else {
          // لا توجد بيانات
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('لا توجد بيانات'),
                content: const Text('لم يتم العثور على أشكال دوائية.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إغلاق'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      print("فشل في جلب البيانات: $e");
    }
  }

  Future<void> addNewMedForm() async {
    try {
      final response = await Dio().post(
        "$baseUrl/api/medicine-forms",
        data: {"name": MedFormName.text, "description": MedFormDesc.text},
      );
      final responseback = response.data['message'];
      Fluttertoast.showToast(
        msg: responseback,
        gravity: ToastGravity.BOTTOM_LEFT,
        backgroundColor: Colors.greenAccent,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendCategoryToApi() async {
    try {
      final response = await Dio().post(
        "$baseUrl/api/add-category",
        data: {
          "name": nameController.text,
          "description": descriptionController.text,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final category = CategoryInfo.fromJson(response.data['category']);
        final box = Hive.box<CategoryInfo>('categorys');
        await box.add(category);
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
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة فئة جديدة'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'send':
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('إضافة شكل دواء'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: MedFormName,
                              decoration: const InputDecoration(
                                labelText: 'الاسم',
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: MedFormDesc,
                              decoration: const InputDecoration(
                                labelText: 'الوصف',
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              MedFormName.clear();
                              MedFormDesc.clear();
                            },
                            child: const Text('إلغاء'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await addNewMedForm();
                              MedFormName.clear();
                              MedFormDesc.clear();
                            },
                            child: const Text('إرسال'),
                          ),
                        ],
                      );
                    },
                  );
                  break;
                case 'view shapes':
                  getCategoryInfo();
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'send',
                    child: Text('إضافة شكل دواء'),
                  ),
                  const PopupMenuItem(
                    value: 'view shapes',
                    child: Text('عرض بيانات الفئة'),
                  ),
                ],
          ),
        ],
      ),
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
            IOSButtons.loadingButton(
              isLoading: isLoading,
              text: "تحميل",
              onPressed: () async {
                setState(() => isLoading = true);
                await Future.delayed(
                  const Duration(seconds: 1),
                  () => sendCategoryToApi(),
                );
                setState(() => isLoading = false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
