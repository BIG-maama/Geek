import 'package:dio/dio.dart';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pro/BottomNavigator/Medicines/medic_&_catg_info.dart';
import 'package:pro/widget/Global.dart';

class MedicineDetailsPage extends StatefulWidget {
  final MedicInfo medicine;

  const MedicineDetailsPage({Key? key, required this.medicine})
    : super(key: key);

  @override
  State<MedicineDetailsPage> createState() => _MedicineDetailsPageState();
}

class _MedicineDetailsPageState extends State<MedicineDetailsPage> {
  List<int> selectedAlternativeIds = [];

  Future<void> deleteMedicine(BuildContext context) async {
    try {
      final response = await Dio().delete(
        "$baseUrl/api/medicines/${widget.medicine.id}",
      );

      if (response.statusCode == 200) {
        await widget.medicine.delete();
        Navigator.of(context).pop();
        FancySnackbar.show(
          context,
          "تم حذف الدواء بنجاح",
          backgroundColor: Colors.red.shade600,
          seconds: 2,
          textColor: Colors.white,
          logo: const Icon(CupertinoIcons.delete_solid),
        );
      } else {
        print("فشل الحذف");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendAlternativeMedicines() async {
    if (selectedAlternativeIds.isEmpty) return;

    try {
      final response = await Dio().post(
        "$baseUrl/api/add-alternative-medicines/${widget.medicine.id}/",
        data: {
          "alternative_ids": selectedAlternativeIds,
          "is_bidirectional": false,
        },
      );

      if (response.statusCode == 200) {
        FancySnackbar.show(
          context,
          "✅ تم إرسال البدائل بنجاح",
          backgroundColor: Colors.green,
          seconds: 2,
          textColor: Colors.white,
          logo: const Icon(Icons.check),
        );
      }
    } catch (e) {
      print("خطأ في الإرسال: $e");
    }
  }

  void showAlternativeSelectionDialog() async {
    final allMedicines =
        Hive.box<MedicInfo>('medics').values
            .where((med) => med.id != widget.medicine.id) //
            .toList();

    await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text("اختر الأدوية البديلة"),
          message: SizedBox(
            height: 300,
            child: StatefulBuilder(
              builder: (context, setStateDialog) {
                return ListView(
                  children:
                      allMedicines.map((med) {
                        final isSelected = selectedAlternativeIds.contains(
                          med.id,
                        );
                        return CupertinoListTile(
                          title: Text(med.name),
                          trailing: CupertinoSwitch(
                            value: isSelected,
                            onChanged: (val) {
                              setStateDialog(() {
                                if (val) {
                                  selectedAlternativeIds.add(med.id);
                                } else {
                                  selectedAlternativeIds.remove(med.id);
                                }
                              });
                            },
                          ),
                        );
                      }).toList(),
                );
              },
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text("إرسال البدائل"),
              onPressed: () {
                Navigator.pop(context);
                sendAlternativeMedicines();
              },
            ),
            CupertinoDialogAction(
              child: const Text(
                "إلغاء",
                style: TextStyle(color: CupertinoColors.destructiveRed),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final med = widget.medicine;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('تفاصيل الدواء'),
        trailing: AnimatedPopupMenu(
          onEdit: showAlternativeSelectionDialog,
          onDelete: () {
            AlertHelper.showConfirmationDialog(
              context: context,
              title: "حذف",
              message: "هل أنت متأكد أنك تريد حذف هذا الدواء؟",
              onConfirm: () async {
                await deleteMedicine(context);
              },
            );
          },
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildInfoTile("💊 اسم الدواء:", med.name),
            _buildInfoTile("📝 الاسم بالعربية:", med.arabicName),
            _buildInfoTile("📦 النوع:", med.type),
            _buildInfoTile("📇 باركود:", med.barcode),
            _buildInfoTile("🔢 الكمية:", med.quantity),
            _buildInfoTile("⚠️ الكمية الحرجة:", med.alertQuantity),
            _buildInfoTile("💰 سعر البيع:", med.prices.peoplePrice.toString()),
            _buildInfoTile(
              "🛒 سعر المورد:",
              med.prices.supplierPrice.toString(),
            ),
            _buildInfoTile("📉 الضريبة:", "${med.prices.taxRate}%"),
            _buildInfoTile("🆔 رقم المعرف:", med.id.toString()),
            _buildInfoTile("📁 مرفقات:", "${med.attachments.length} عنصر"),
          ],
        ),
      ),
    );
  }
}

Widget _buildInfoTile(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: CupertinoListTile(
      title: Text(label),
      subtitle: Text(value.isNotEmpty ? value : "لا يوجد"),
      leading: const Icon(CupertinoIcons.info),
    ),
  );
}
