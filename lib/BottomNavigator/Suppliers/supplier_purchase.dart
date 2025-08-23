import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:pro/widget/Global.dart';

class SupplierPurchasesScreen extends StatefulWidget {
  final int supplierId;
  const SupplierPurchasesScreen(this.supplierId, {super.key});

  @override
  State<SupplierPurchasesScreen> createState() =>
      _SupplierPurchasesScreenState();
}

class _SupplierPurchasesScreenState extends State<SupplierPurchasesScreen> {
  bool isLoading = true;
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    fetchSupplierData();
  }

  Future<void> fetchSupplierData() async {
    try {
      final response = await Dio().get(
        "$baseUrl/api/suppliers-purchases/${widget.supplierId}",
      );

      if (response.statusCode == 200) {
        print(response.data);
        if (response.statusCode == 200) {
          setState(() {
            data = response.data['data']; // هنا ناخذ المحتوى الداخلي
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ حدث خطأ أثناء جلب البيانات")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text("📊 مشتريات المورد"),
          centerTitle: true,
          backgroundColor: Colors.blueGrey.shade700,
        ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : (data == null || (data!['purchases'] as List).isEmpty)
                ? const Center(
                  child: Text(
                    "لا يوجد مشتريات لهذا المورد",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // 🏢 بطاقة المورد
                      GlassmorphicContainer(
                        width: double.infinity,
                        height: 120,
                        borderRadius: 20,
                        blur: 15,
                        alignment: Alignment.center,
                        border: 2,
                        linearGradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.white.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderGradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.5),
                            Colors.purple.withOpacity(0.5),
                          ],
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue.shade400,
                            child: const Icon(
                              Icons.business,
                              color: Colors.white,
                            ),
                          ),
                          title: AutoSizeText(
                            "🏢 ${data!['supplier']['company_name']}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            "👤 ${data!['supplier']['contact_person_name']}",
                          ),
                        ),
                      ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),
                      const SizedBox(height: 20),

                      // 📦 قائمة المشتريات
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "📦 المشتريات",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      AnimationLimiter(
                        child: Column(
                          children: List.generate((data!['purchases'] as List).length, (
                            index,
                          ) {
                            final purchase =
                                (data!['purchases'] as List)[index];
                            final items = purchase['items'] as List;

                            return Column(
                              children: [
                                AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 400),
                                  child: SlideAnimation(
                                    horizontalOffset: 50,
                                    child: FadeInAnimation(
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        elevation: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "طلب #${index + 1}",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blueGrey,
                                                    ),
                                                  ),
                                                  Text(
                                                    "عدد المنتجات: ${purchase['items_count']}",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.teal,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Wrap(
                                                spacing: 8,
                                                runSpacing: 6,
                                                children:
                                                    items
                                                        .map(
                                                          (item) => Chip(
                                                            avatar: const Icon(
                                                              Icons.medication,
                                                              size: 18,
                                                              color:
                                                                  Colors.teal,
                                                            ),
                                                            label: Text(
                                                              "${item['medicine_name']} ×${item['quantity']}",
                                                              style:
                                                                  const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                            ),
                                                            backgroundColor:
                                                                Colors
                                                                    .teal
                                                                    .shade50,
                                                          ),
                                                        )
                                                        .toList(),
                                              ),
                                              const SizedBox(height: 12),
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text(
                                                  "تمت الإضافة: ${purchase['date']}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (index <
                                    (data!['purchases'] as List).length - 1)
                                  Divider(
                                    color: Colors.grey.shade400,
                                    thickness: 0.8,
                                    indent: 20,
                                    endIndent: 20,
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 📊 الإحصائيات
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "📊 الإحصائيات",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 250,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 150,
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY:
                                        (data!['statistics']['total_orders']
                                                as num)
                                            .toDouble(),
                                    color: Colors.blue,
                                    width: 20,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    toY:
                                        (data!['statistics']['total_paid']
                                                as num)
                                            .toDouble(),
                                    color: Colors.green,
                                    width: 20,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 2,
                                barRods: [
                                  BarChartRodData(
                                    toY:
                                        (data!['statistics']['total_unpaid']
                                                as num)
                                            .toDouble(),
                                    color: Colors.red,
                                    width: 20,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ],
                              ),
                            ],
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    switch (value.toInt()) {
                                      case 0:
                                        return const Text("الطلبات");
                                      case 1:
                                        return const Text("مدفوع");
                                      case 2:
                                        return const Text("غير مدفوع");
                                    }
                                    return const Text("");
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3),
                    ],
                  ),
                ),
      ),
    );
  }
}
