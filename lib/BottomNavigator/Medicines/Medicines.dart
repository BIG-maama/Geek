import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pro/BottomNavigator/Medicines/group_medic_page.dart';
import 'package:pro/BottomNavigator/Medicines/add_new_medic.dart';
import 'package:pro/BottomNavigator/Medicines/create_category.dart';
import 'package:pro/BottomNavigator/Medicines/medic_&_catg_info.dart';
import 'package:pro/widget/Global.dart';

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
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('فئات الأدوية')),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: IOSButtons.iconButton(
                      text: "اضافة فئة ",
                      onPressed: () {
                        // CustomNavigator.push(context, AddCategoryPage());
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddCategoryPage()),
                        );
                      },
                      icon: CupertinoIcons.cube_box,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: IOSButtons.iconButton(
                      onPressed: () {
                        //  CustomNavigator.push(context, AddMedicineModern());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddMedicineModern(),
                          ),
                        );
                      },
                      text: 'اضافة دواء',
                      icon: CupertinoIcons.bandage,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: categoryBox.listenable(),
                builder: (context, Box<CategoryInfo> box, _) {
                  if (box.isEmpty) {
                    return const Center(
                      child: Text(
                        'لا توجد فئات مضافة بعد.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final item = box.getAt(index);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey6,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: CupertinoColors.separator, // Divider خفيف
                              width: 0.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: CupertinoColors.systemGrey5.withOpacity(
                                  0.2,
                                ),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CupertinoListTile(
                            title: Text(
                              item?.name ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              item?.description ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                GroupedMedicinesCupertinoPage(
                                                  category: item!,
                                                ),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    CupertinoIcons.list_bullet_indent,
                                    color: CupertinoColors.activeBlue,
                                  ),
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () async {
                                    AlertHelper.showConfirmationDialog(
                                      context: context,
                                      title: "تأكيد الحذف",
                                      message:
                                          "هل أنت متأكد من حذف هذا العنصر؟",
                                      onConfirm: () async {
                                        await box.deleteAt(index);
                                        Fluttertoast.showToast(
                                          msg: "the category has been deleted",
                                          backgroundColor: Colors.redAccent,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                      },
                                    );
                                  },
                                  child: const Icon(
                                    CupertinoIcons.delete,
                                    color: CupertinoColors.destructiveRed,
                                  ),
                                ),
                              ],
                            ),
                            leading: const Icon(
                              CupertinoIcons.cube_box,
                              color: CupertinoColors.systemTeal,
                              size: 28,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
