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
  late MedicInfo med;
  bool isLoading = false;
  bool _pressed = false;
  List<int> selectedAlternativeIds = [];

  @override
  void initState() {
    super.initState();
    med = widget.medicine;
    fetchMedicineDetails();
  }

  Future<void> fetchMedicineDetails() async {
    setState(() => isLoading = true);
    try {
      final response = await Dio().get("$baseUrl/api/medicines/${med.id}");
      if (response.statusCode == 200 && response.data['status'] == true) {
        final updated = response.data['data'];
        setState(() {
          med = MedicInfo.fromJson(updated);
        });
      }
    } catch (e) {
      print("خطأ في جلب التفاصيل: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteMedicine(BuildContext context) async {
    try {
      final response = await Dio().delete(
        "$baseUrl/api/medicines/${widget.medicine.id}",
      );
      if (response.statusCode == 200) {
        FancySnackbar.show(
          context,
          "تم حذف الدواء بنجاح",
          backgroundColor: Colors.red.shade600,
          seconds: 2,
          textColor: Colors.white,
          logo: const Icon(CupertinoIcons.delete_solid),
        );
        await widget.medicine.delete();
        Navigator.pop(context);
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

  void post_expired_med(int medicineId) async {
    final quantityController = TextEditingController();
    final reasonController = TextEditingController();
    final notesController = TextEditingController();

    await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text("تسجيل دواء تالف"),
          message: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CupertinoTextField(
                  controller: quantityController,
                  placeholder: "الكمية التالفة",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                CupertinoTextField(
                  controller: reasonController,
                  placeholder: "السبب (مثلاً: منتهي الصلاحية)",
                ),
                const SizedBox(height: 10),
                CupertinoTextField(
                  controller: notesController,
                  placeholder: "ملاحظات إضافية (اختياري)",
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text("إرسال"),
              onPressed: () async {
                Navigator.pop(context);

                final int? quantity = int.tryParse(quantityController.text);
                final String reason = reasonController.text.trim();
                final String notes = notesController.text.trim();

                if (quantity == null || reason.isEmpty) {
                  showCupertinoDialog(
                    context: context,
                    builder:
                        (context) => CupertinoAlertDialog(
                          title: Text("تحذير"),
                          content: Text("يرجى إدخال الكمية والسبب."),
                          actions: [
                            CupertinoDialogAction(
                              child: Text("موافق"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                  );
                  return;
                }

                try {
                  final response = await Dio().post(
                    "$baseUrl/api/add-damaged-medicine",
                    data: {
                      "medicine_id": medicineId,
                      "quantity_talif": quantity,
                      "reason": reason,
                      "notes": notes,
                    },
                  );

                  if (response.statusCode == 201 &&
                      response.data["status"] == "success") {
                    showCupertinoDialog(
                      context: context,
                      builder:
                          (context) => CupertinoAlertDialog(
                            title: Text("تم بنجاح"),
                            content: Text(response.data["message"]),
                            actions: [
                              CupertinoDialogAction(
                                child: Text("موافق"),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                    );
                  } else {
                    throw Exception("فشل في الإرسال");
                  }
                } catch (e) {
                  showCupertinoDialog(
                    context: context,
                    builder:
                        (context) => CupertinoAlertDialog(
                          title: Text("خطأ"),
                          content: Text("فشل في الاتصال أو إرسال البيانات: $e"),
                          actions: [
                            CupertinoDialogAction(
                              child: Text("إغلاق"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                  );
                }
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text("إلغاء"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void showAlternativeSelectionDialog() async {
    final allMedicines =
        Hive.box<MedicInfo>(
          'medics',
        ).values.where((m) => m.id != widget.medicine.id).toList();

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
              onPressed: () async {
                Navigator.pop(context);
                await sendAlternativeMedicines();
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('تفاصيل الدواء'),
        trailing: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: () => _showActionsSheet(context),
          child: AnimatedScale(
            scale: _pressed ? 0.85 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: const Icon(CupertinoIcons.ellipsis),
          ),
        ),
      ),
      child: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CupertinoColors.systemGroupedBackground,
                _getMainColor(),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child:
              isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : CustomScrollView(
                    slivers: [
                      CupertinoSliverRefreshControl(
                        onRefresh: fetchMedicineDetails,
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            _animatedSection(
                              _buildSection(
                                context,
                                "💊 معلومات عامة",
                                children: [
                                  _infoTile("الاسم", med.name),
                                  _infoTile("الاسم بالعربية", med.arabicName),
                                  _infoTile("الباركود", med.barcode),
                                  _infoTile("النوع", med.type),
                                  _infoTile("الكمية", med.quantity.toString()),
                                  _infoTile(
                                    "الكمية الحرجة",
                                    med.alertQuantity.toString(),
                                  ),
                                ],
                              ),
                              delay: 200,
                            ),
                            _animatedSection(
                              _buildSection(
                                context,
                                "💰 الأسعار",
                                children: [
                                  _infoTile(
                                    "سعر المورد",
                                    "${med.prices.supplierPrice}",
                                  ),
                                  _infoTile(
                                    "سعر البيع",
                                    "${med.prices.peoplePrice}",
                                  ),
                                  _infoTile(
                                    "الضريبة",
                                    "${med.prices.taxRate}%",
                                  ),
                                ],
                              ),
                              delay: 400,
                            ),
                            _animatedSection(
                              _buildSection(
                                context,
                                "📁 التصنيفات",
                                children: [
                                  _infoTile("القسم", med.category.name),
                                  _infoTile("الشكل", med.medicineForm.name),
                                  _infoTile(
                                    "الوصف",
                                    med.medicineForm.description,
                                  ),
                                ],
                              ),
                              delay: 600,
                            ),
                            _animatedSection(
                              _buildSection(
                                context,
                                "🧪 الحالة",
                                children: [
                                  _statusTile(
                                    "منتهي الصلاحية",
                                    med.status.isExpired,
                                    activeColor: CupertinoColors.systemRed,
                                  ),
                                  _statusTile(
                                    "قارب على الانتهاء",
                                    med.status.isExpiringSoon,
                                    activeColor: CupertinoColors.systemYellow,
                                  ),
                                  _statusTile(
                                    "الكمية منخفضة",
                                    med.status.isLow,
                                    activeColor: CupertinoColors.systemOrange,
                                  ),
                                  _statusTile(
                                    "نفذ من المخزون",
                                    med.status.isOut,
                                    activeColor: CupertinoColors.systemGrey,
                                  ),
                                ],
                              ),
                              delay: 800,
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  void _showActionsSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (_) => CupertinoActionSheet(
            title: const Text("الخيارات"),
            actions: [
              CupertinoActionSheetAction(
                onPressed: showAlternativeSelectionDialog,
                child: const Text("تعديل"),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context); // نغلق النافذة قبل فتح نافذة الإتلاف
                  post_expired_med(widget.medicine.id); // تمرير معرف الدواء
                },
                child: Text("إتلاف الدواء"),
              ),
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () async {
                  await deleteMedicine(context);
                  Navigator.pop(context);
                },
                child: const Text("حذف"),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
          ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title, {
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CupertinoListSection.insetGrouped(
        header: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: children,
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return CupertinoListTile(
      title: Text(title),
      subtitle: Text(value.isNotEmpty ? value : "لا يوجد"),
      leading: const Icon(CupertinoIcons.info_circle),
    );
  }

  Widget _statusTile(String title, bool value, {Color? activeColor}) {
    final icon =
        value
            ? CupertinoIcons.check_mark_circled_solid
            : CupertinoIcons.clear_circled;

    return TweenAnimationBuilder<Color?>(
      duration: const Duration(milliseconds: 500),
      tween: ColorTween(
        begin: CupertinoColors.systemGrey6,
        end:
            value
                ? (activeColor ?? CupertinoColors.systemGreen).withOpacity(0.1)
                : CupertinoColors.systemGrey6,
      ),
      builder: (context, color, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (value)
                BoxShadow(
                  color: (activeColor ?? CupertinoColors.activeBlue)
                      .withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(
                icon,
                color:
                    value
                        ? (activeColor ?? CupertinoColors.activeGreen)
                        : CupertinoColors.systemGrey,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color:
                        value
                            ? (activeColor ?? CupertinoColors.activeGreen)
                            : CupertinoColors.systemGrey,
                  ),
                ),
              ),
              Text(
                value ? "نعم" : "لا",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _animatedSection(Widget child, {int delay = 0}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      child: child,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 20),
          child: Opacity(opacity: value, child: child),
        );
      },
    );
  }

  Color _getMainColor() {
    if (med.status.isExpired)
      return CupertinoColors.systemRed.withOpacity(0.05);
    if (med.status.isLow) return CupertinoColors.systemYellow.withOpacity(0.05);
    return CupertinoColors.systemGreen.withOpacity(0.05);
  }
}
