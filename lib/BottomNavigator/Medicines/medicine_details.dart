import 'dart:ui';

import 'package:animated_button/animated_button.dart';
import 'package:dio/dio.dart';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pro/BottomNavigator/Medicines/medic_&_catg_info.dart';
import 'package:pro/widget/Global.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
        final updatedData = response.data['data'];

        // نحتفظ بالمرفقات القديمة
        final oldAttachments = med.attachments;

        // نحدث باقي البيانات
        final updatedMed = MedicInfo.fromJson(updatedData);

        // نعيد إدخال المرفقات القديمة
        med = updatedMed..attachments = oldAttachments;

        setState(() {}); // لتحديث الواجهة
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
    final Attachment? pdfAttachment =
        med.attachments
            .where((att) => att.fullUrl.toLowerCase().endsWith('.pdf'))
            .cast<Attachment?>()
            .firstOrNull;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('🧾 تفاصيل الدواء'),
        trailing: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: () => _showActionsSheet(context),
          child: AnimatedScale(
            scale: _pressed ? 0.85 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: const Icon(CupertinoIcons.ellipsis_circle),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "📷 صور الدواء",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    height: 220,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: med.attachments.length,
                                      separatorBuilder:
                                          (_, __) => const SizedBox(width: 12),
                                      itemBuilder: (context, index) {
                                        final attachment =
                                            med.attachments[index];
                                        if (!attachment.fullUrl
                                                .toLowerCase()
                                                .endsWith('.jpg') &&
                                            !attachment.fullUrl
                                                .toLowerCase()
                                                .endsWith('.jpeg') &&
                                            !attachment.fullUrl
                                                .toLowerCase()
                                                .endsWith('.png')) {
                                          return const SizedBox.shrink();
                                        }

                                        final imageUrl = attachment.fullUrl
                                            .replaceFirst(
                                              'localhost',
                                              '192.168.1.107',
                                            );

                                        return GestureDetector(
                                          onLongPress: () {
                                            showDialog(
                                              context: context,
                                              builder:
                                                  (_) => Dialog(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  16,
                                                                ),
                                                            color: Colors.black,
                                                          ),
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8,
                                                              ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                            child: Image.network(
                                                              imageUrl,
                                                              fit:
                                                                  BoxFit
                                                                      .contain,
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 10,
                                                          right: 10,
                                                          child: GestureDetector(
                                                            onTap:
                                                                () =>
                                                                    Navigator.of(
                                                                      context,
                                                                    ).pop(),
                                                            child: const CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              child: Icon(
                                                                Icons.close,
                                                                color:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                            );
                                          },
                                          child: Tilt(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            tiltConfig: const TiltConfig(
                                              angle: 15,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Stack(
                                                children: [
                                                  Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey.shade300,
                                                    highlightColor:
                                                        Colors.grey.shade100,
                                                    child: Container(
                                                      width: 340,
                                                      height: 200,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Image.network(
                                                    imageUrl,
                                                    height: 200,
                                                    width: 340,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (
                                                      context,
                                                      child,
                                                      loadingProgress,
                                                    ) {
                                                      if (loadingProgress ==
                                                          null)
                                                        return child;
                                                      return const Center(
                                                        child:
                                                            CupertinoActivityIndicator(),
                                                      );
                                                    },
                                                    errorBuilder:
                                                        (
                                                          _,
                                                          __,
                                                          ___,
                                                        ) => Container(
                                                          color:
                                                              Colors.grey[300],
                                                          width: 140,
                                                          height: 200,
                                                          child: const Icon(
                                                            CupertinoIcons
                                                                .photo,
                                                          ),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // معلومات عامة
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

                            // الأسعار
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

                            // التصنيفات
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

                            // الحالة
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
                            const SizedBox(height: 16),
                            if (med.attachments.isNotEmpty)
                              _animatedSection(
                                _buildAttachmentSection(pdfAttachment?.fullUrl),
                                delay: 1000,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildAttachmentSection(String? pdfUrl) {
    final hasPdf = pdfUrl != null && pdfUrl.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child:
              hasPdf
                  ? SfPdfViewer.network(
                    pdfUrl,
                    canShowScrollStatus: true,
                    canShowPaginationDialog: true,
                    onDocumentLoadFailed: (details) {
                      // يسجل الخطأ في حال فشل التحميل
                      debugPrint("فشل تحميل الملف PDF: ${details.description}");
                    },
                  )
                  : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.doc_text,
                          size: 48,
                          color: CupertinoColors.systemGrey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          "لا يوجد مرفقات خاصة بهذا الدواء",
                          style: TextStyle(
                            fontSize: 16,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
            ),
            const SizedBox(height: 12),
            ...children.map(
              (child) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: child,
              ),
            ),
          ],
        ),
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

  Widget _statusTile(
    String title,
    bool value, {
    Color? activeColor,
    bool isCritical = false, // تحدد لو الحالة حرجة للرجفة
  }) {
    activeColor ??= Colors.green;
    final icon = value ? Icons.check_circle_rounded : Icons.cancel_rounded;

    // لوحة الألوان الخلفية
    final backgroundColor =
        value ? activeColor.withOpacity(0.15) : Colors.grey.shade200;
    final textColor = value ? activeColor : Colors.teal.shade600;
    final iconColor = value ? activeColor : Colors.grey.shade500;

    Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow:
            value
                ? [
                  BoxShadow(
                    color: activeColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
                : [],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: textColor,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: value ? activeColor : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (value ? activeColor : Colors.grey.shade400)
                      .withOpacity(0.6),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              value ? "نعم" : "لا",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );

    // نضيف تأثير الميل (tilt) للبطاقة كلها
    content = Tilt(
      borderRadius: BorderRadius.circular(18),
      tiltConfig: const TiltConfig(angle: 10),
      child: content,
    );

    // نضيف تأثير الرجفة اذا الحالة حرجة (مثل منتهي الصلاحية)
    if (isCritical && !value) {
      content = ShakeWidget(
        shakeConstant: ShakeHorizontalConstant1(),
        autoPlay: true,
        child: content,
      );
    }

    // نضيف حركة دخول ناعمة (fade + slide)
    return content
        .animate()
        .fadeIn(duration: 600.ms)
        .slide(begin: const Offset(0, 0.15));
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
}
