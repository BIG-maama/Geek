import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pro/invoices/invocies_pro.dart';
import 'package:pro/payment/pay.dart';
import 'package:pro/widget/Global.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class UnpaidInvoicesPage extends StatefulWidget {
  const UnpaidInvoicesPage({Key? key}) : super(key: key);

  @override
  State<UnpaidInvoicesPage> createState() => _UnpaidInvoicesPageState();
}

class _UnpaidInvoicesPageState extends State<UnpaidInvoicesPage> {
  bool isLoading = false;
  late Box<Invoice> unpaidInvoiceBox;

  @override
  void initState() {
    super.initState();
    initHiveAndFetch();
  }

  Future<void> initHiveAndFetch() async {
    unpaidInvoiceBox = await Hive.openBox<Invoice>('unpaidInvoices');
    await fetchUnpaidInvoices();
  }

  Future<void> _downloadPdf(int invoiceId) async {
    var status = await Permission.storage.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ الرجاء منح صلاحية التخزين للتحميل")),
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Center(
            child: Lottie.asset(
              "assets/lottie/Downloading.json",
              width: 150,
              repeat: true,
            ),
          ),
    );

    try {
      Directory? dir;
      if (Platform.isAndroid) {
        dir = Directory("/storage/emulated/0/Documents");
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final filePath = "${dir.path}/invoice_$invoiceId.pdf";
      final dio = Dio();

      final response = await dio.download(
        "$baseUrl/api/invoices/$invoiceId/download-pdf",
        filePath,
      );

      Navigator.pop(context); // ✅ إغلاق اللوتي

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ تم تنزيل الفاتورة في: $filePath")),
        );
      } else {
        throw Exception("فشل في تنزيل الملف");
      }
    } catch (e) {
      Navigator.pop(context); // ✅ إغلاق اللوتي في حال الخطأ
      debugPrint("❌ خطأ أثناء تنزيل PDF: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("فشل تنزيل الفاتورة")));
    }
  }

  Future<void> fetchUnpaidInvoices() async {
    setState(() => isLoading = true);

    try {
      final response = await Dio().get("$baseUrl/api/show-unpaid-invoices");

      if (response.statusCode == 200 &&
          response.data['success'] == true &&
          response.data['invoices'] != null) {
        List invoicesJson = response.data['invoices'];

        List<Invoice> invoices =
            invoicesJson.map((json) => Invoice.fromJson(json)).toList();

        await unpaidInvoiceBox.clear();
        await unpaidInvoiceBox.addAll(invoices);

        debugPrint(
          "✅ تم تخزين الفواتير الغير مدفوعة في Hive: ${invoices.length}",
        );
      }
    } catch (e) {
      debugPrint("❌ خطأ أثناء جلب الفواتير الغير مدفوعة: $e");
    }

    await Future.delayed(const Duration(seconds: 2));
    setState(() => isLoading = false);
  }

  /// 🔹 عرض أيقونة/Lottie حسب حالة الفاتورة
  Widget getStatusLottie(String status) {
    switch (status) {
      case "unpaid":
        return Lottie.asset(
          "assets/lottie/payment - fd.json",
          width: 60,
          repeat: false,
        );

      default:
        return const Icon(Icons.help, color: Colors.grey);
    }
  }

  Future<void> showInvoiceDetails(int invoiceId) async {
    try {
      final response = await Dio().get(
        "$baseUrl/api/show-invoice-details/$invoiceId",
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final invoice = response.data['invoice'];

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "🧾 فاتورة #${invoice['invoice_number']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("📅 التاريخ: ${invoice['invoice_date']}"),
                      Text("📅 الاستحقاق: ${invoice['due_date']}"),
                      Text("👤 المورد: ${invoice['supplier_name']}"),
                      Text("💰 المبلغ: ${invoice['total_amount']}"),
                      Text("📦 عدد المنتجات: ${invoice['items_count']}"),
                      const Divider(),
                      const Text(
                        "🧪 الأدوية:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            (invoice['medicines'] as List)
                                .map(
                                  (med) => Text(
                                    "- ${med['medicine_name']} (x${med['quantity']}) = ${med['total_price']}",
                                  ),
                                )
                                .toList(),
                      ),
                      const Divider(),
                      if (invoice['notes'] != null)
                        Text("📝 ملاحظات: ${invoice['notes']}"),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // 🔹 زر عرض PDF
                          ElevatedButton.icon(
                            onPressed: () {
                              _showPdfPreview(
                                context,
                                "$baseUrl/api/invoices/${invoice['id']}/view-pdf",
                              );
                            },
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text("عرض الفاتورة PDF"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                          ),

                          // 🔹 زر تحميل PDF
                          ElevatedButton.icon(
                            onPressed: () async {
                              await _downloadPdf(invoice['id']);
                            },
                            icon: const Icon(Icons.download),
                            label: const Text("تحميل PDF"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      debugPrint("❌ خطأ في جلب تفاصيل الفاتورة: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("فشل تحميل تفاصيل الفاتورة")),
      );
    }
  }

  void _showPdfPreview(BuildContext context, String pdfUrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Stack(
            children: [
              SfPdfViewer.network(
                pdfUrl,
                canShowScrollHead: true,
                canShowScrollStatus: true,
                onDocumentLoadFailed: (details) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("فشل تحميل PDF: ${details.description}"),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text("🧾 الفواتير الغير مدفوعة"),
          centerTitle: true,
          backgroundColor: Colors.red.shade700,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: fetchUnpaidInvoices,
            ),
          ],
        ),
        body:
            isLoading
                ? Center(
                  child: Lottie.asset(
                    "assets/lottie/Loading Files.json",
                    width: 200,
                  ),
                )
                : ValueListenableBuilder(
                  valueListenable: unpaidInvoiceBox.listenable(),
                  builder: (context, Box<Invoice> box, _) {
                    if (box.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              "assets/lottie/No-Data.json",
                              width: 200,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "لا يوجد فواتير غير مدفوعة حالياً",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final invoices = box.values.toList();
                    return AnimationLimiter(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: invoices.length,
                        itemBuilder: (context, index) {
                          final invoice = invoices[index];

                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              verticalOffset: 50,
                              child: FadeInAnimation(
                                child: Card(
                                  elevation: 4,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "فاتورة #${invoice.invoiceNumber}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            getStatusLottie(invoice.status),
                                          ],
                                        ),
                                        const Divider(),
                                        Text(
                                          "📅 تاريخ الفاتورة: ${invoice.invoiceDate}",
                                        ),
                                        Text(
                                          "📅 تاريخ الاستحقاق: ${invoice.dueDate}",
                                        ),
                                        Text(
                                          "👤 المورد: ${invoice.supplierName}",
                                        ),
                                        Text(
                                          "💰 المبلغ الكلي: ${invoice.totalAmount}",
                                        ),
                                        Text(
                                          "📦 عدد المنتجات: ${invoice.itemsCount}",
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          spacing: 25,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.red.shade700,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                icon: const Icon(Icons.info),
                                                label: const Text(
                                                  "تفاصيل",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onPressed:
                                                    () => showInvoiceDetails(
                                                      invoice.id,
                                                    ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.amber,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                icon: Lottie.asset(
                                                  "assets/lottie/creditcard.json",
                                                  width: 40,
                                                  height: 40,
                                                  repeat: true,
                                                ),
                                                label: const Text(
                                                  "ادفع",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onPressed:
                                                    () => Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        type:
                                                            PageTransitionType
                                                                .leftToRight,
                                                        child:
                                                            InvoicePaymentPage(
                                                              invoice.id,
                                                              invoiceId:
                                                                  invoice.id,
                                                            ),
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
