import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pro/BottomNavigator/Suppliers/addNewSuppplier.dart';
import 'package:pro/BottomNavigator/Suppliers/supplier_info.dart';
import 'package:pro/widget/Global.dart';
import 'supplier_profile.dart';

class SuppliersPage extends StatelessWidget {
  const SuppliersPage({super.key});

  Future<Map<String, dynamic>?> fetchSupplierDetails(int supplierId) async {
    try {
      final response = await Dio().get(
        "$baseUrl/api/show-supplier-details/$supplierId",
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        return response.data['data'];
      } else {
        print("خطأ في البيانات: ${response.data['message']}");
        return null;
      }
    } catch (e) {
      print("حدث خطأ أثناء الاتصال بالـ API: $e");
      return null;
    }
  }

  Future<void> deleteSupplier(int ID) async {
    final response = await Dio().delete('$baseUrl/api/suppliers/$ID');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      BotToast.showText(
        text: (data['message'] as String?) ?? 'تم الحذف بنجاح',

        duration: Duration(seconds: 2),
        contentColor: Colors.teal,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<SupplierProfile>('suppliers');

    return Scaffold(
      appBar: AppBar(title: const Text("قائمة الموردين")),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<SupplierProfile> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("لا يوجد موردين حالياً"));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final supplier = box.getAt(index)!;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.teal.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Text(
                    supplier.company_name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("📞 ${supplier.phone}"),
                  children: [
                    _buildDataRow("اسم المسؤول:", supplier.contact_person_name),
                    _buildDataRow("📧 البريد الإلكتروني:", supplier.email),
                    _buildDataRow("🏠 العنوان:", supplier.address),
                    _buildDataRow("💳 طريقة الدفع:", supplier.payment_method),
                    _buildDataRow(
                      "💰 حد الائتمان:",
                      supplier.credit_limit.toString(),
                    ),
                    _buildDataRow("📅 التاريخ:", supplier.date),
                    _buildDataRow("🔢 ID:", supplier.id.toString()),
                    _buildDataRow(
                      "✅ الحالة:",
                      supplier.status ? "نشط" : "غير نشط",
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final data = await fetchSupplierDetails(
                              supplier.id,
                            );
                            if (data != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => SupplierDetailsPage(
                                        supplierData: data,
                                      ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("فشل في تحميل بيانات المورد"),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.visibility),
                          label: const Text("عرض"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text("delete confirmation"),
                                    content: const Text(
                                      " are you sure you want to delete this supplier ? ",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, false),
                                        child: const Text("إلغاء"),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, true),
                                        child: const Text("نعم، احذف"),
                                      ),
                                    ],
                                  ),
                            );

                            if (confirm ?? false) {
                              await deleteSupplier(supplier.id);
                              await box.deleteAt(index);
                            }
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text("حذف"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddSupplierPage()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: "إضافة مورد جديد",
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
