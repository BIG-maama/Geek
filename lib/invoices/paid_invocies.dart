import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pro/invoices/invocies_pro.dart';
import 'package:pro/widget/Global.dart';

class PaidInvoicesPage extends StatefulWidget {
  const PaidInvoicesPage({Key? key}) : super(key: key);

  @override
  State<PaidInvoicesPage> createState() => _PaidInvoicesPageState();
}

class _PaidInvoicesPageState extends State<PaidInvoicesPage> {
  bool isLoading = false;
  late Box<Invoice> paidInvoiceBox;

  @override
  void initState() {
    super.initState();
    initHiveAndFetch();
  }

  Future<void> initHiveAndFetch() async {
    paidInvoiceBox = await Hive.openBox<Invoice>('paidInvoices');
    await fetchPaidInvoices();
  }

  /// 🔹 جلب الفواتير المدفوعة فقط
  Future<void> fetchPaidInvoices() async {
    setState(() => isLoading = true);

    try {
      final response = await Dio().get("$baseUrl/api/show-paid-invoices");

      if (response.statusCode == 200 &&
          response.data['success'] == true &&
          response.data['invoices'] != null) {
        List invoicesJson = response.data['invoices'];

        List<Invoice> invoices =
            invoicesJson.map((json) => Invoice.fromJson(json)).toList();

        await paidInvoiceBox.clear();
        await paidInvoiceBox.addAll(invoices);

        debugPrint("✅ تم تخزين الفواتير المدفوعة في Hive: ${invoices.length}");
      }
    } catch (e) {
      debugPrint("❌ خطأ أثناء جلب الفواتير المدفوعة: $e");
    }

    await Future.delayed(const Duration(seconds: 2));
    setState(() => isLoading = false);
  }

  /// 🔹 عرض أيقونة/Lottie حسب حالة الفاتورة
  Widget getStatusLottie(String status) {
    switch (status) {
      case "paid":
        return Lottie.asset(
          "assets/lottie/Success.json",
          width: 60,
          repeat: false,
        );
      case "unpaid":
        return Lottie.asset(
          "assets/lottie/payment - fd.json",
          width: 60,
          repeat: false,
        );
      case "partially":
        return Lottie.asset(
          "assets/lottie/payment.json",
          width: 60,
          repeat: false,
        );
      default:
        return const Icon(Icons.help, color: Colors.grey);
    }
  }

  /// 🔹 عرض تفاصيل الفاتورة (من API)
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
              textDirection: TextDirection.rtl,
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text("🧾 الفواتير المدفوعة"),
          centerTitle: true,
          backgroundColor: Colors.green.shade700,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: fetchPaidInvoices,
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
                  valueListenable: paidInvoiceBox.listenable(),
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
                              "لا يوجد فواتير مدفوعة حالياً",
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
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.green.shade700,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
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
