import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pro/widget/Global.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flip_card/flip_card.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SupplierScreenDetailes extends StatefulWidget {
  final int supplierId;

  SupplierScreenDetailes(this.supplierId, {Key? key}) : super(key: key);

  @override
  State<SupplierScreenDetailes> createState() => _SupplierScreenDetailesState();
}

class _SupplierScreenDetailesState extends State<SupplierScreenDetailes> {
  bool isLoading = true;
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    fetchSupplierData(); // ✅ جلب البيانات عند الدخول
  }

  Future<void> fetchSupplierData() async {
    try {
      final response = await Dio().get(
        "$baseUrl/api/suppliers/${widget.supplierId}",
      );

      if (response.statusCode == 200) {
        print(response.data);
        setState(() {
          data = response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      print("❌ خطأ في جلب البيانات: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: SpinKitFadingCircle(color: Colors.teal, size: 15)),
      );
    }

    if (data == null) {
      return Scaffold(body: Center(child: Text("فشل في تحميل البيانات 🚫")));
    }

    final supplier = data!["data"]["supplier"];
    final stats = data!["data"]["statistics"];
    final orderStatus = stats["order_status_breakdown"];
    final totalOrders =
        (stats["total_orders"] ?? 0) + (stats["total_purchases"] ?? 0);

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        backgroundColor: Colors.green[700],
        children: [
          SpeedDialChild(
            child: Icon(Icons.phone, color: Colors.white),
            label: 'اتصال',
            backgroundColor: Colors.green,
          ),
          SpeedDialChild(
            child: Icon(Icons.email, color: Colors.white),
            label: 'إرسال إيميل',
            backgroundColor: Colors.blue,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.greenAccent.shade100,
              Colors.green.shade200,
              Colors.green.shade300,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ✅ الهيدر
                GlassmorphicContainer(
                  width: double.infinity,
                  height: 180,
                  borderRadius: 20,
                  blur: 25,
                  alignment: Alignment.center,
                  border: 2,
                  linearGradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.25),
                      Colors.white.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderGradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.4),
                      Colors.white.withOpacity(0.4),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            supplier["company_name"] ?? "",
                            textStyle: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        supplier["contact_person_name"] ?? "",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // ✅ الكروت الإحصائية
                statCard(
                  title: "إجمالي الطلبات",
                  value: stats["total_orders"],
                  icon: Icons.list_alt_rounded,
                  color: Colors.cyan.shade400,
                ),
                SizedBox(height: 16),
                statCard(
                  title: "إجمالي المشتريات",
                  value: stats["total_purchases"],
                  icon: Icons.shopping_cart_rounded,
                  color: Colors.cyan.shade400,
                ),
                SizedBox(height: 16),
                statCard(
                  title: "متوسط قيمة الطلب",
                  value: stats["average_order_value"],
                  icon: Icons.monetization_on_rounded,
                  color: Colors.cyan.shade400,
                ),

                SizedBox(height: 30),

                // ✅ رسم بياني
                totalOrders == 0
                    ? Center(
                      child: Text(
                        "لا توجد بيانات لحالة الطلبات",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.cyan.shade400,
                        ),
                      ),
                    )
                    : Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      child: Container(
                        height: 280,
                        padding: EdgeInsets.all(16),
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 3,
                            centerSpaceRadius: 40,
                            sections: [
                              PieChartSectionData(
                                value: (orderStatus["pending"] ?? 0).toDouble(),
                                color: Colors.orangeAccent,
                                title: "${orderStatus["pending"]}",
                                radius: 60,
                                titleStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                value:
                                    (orderStatus["confirmed"] ?? 0).toDouble(),
                                color: Colors.blueAccent,
                                title: "${orderStatus["confirmed"]}",
                                radius: 60,
                                titleStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                value:
                                    (orderStatus["completed"] ?? 0).toDouble(),
                                color: Colors.green,
                                title: "${orderStatus["completed"]}",
                                radius: 60,
                                titleStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                value:
                                    (orderStatus["cancelled"] ?? 0).toDouble(),
                                color: Colors.redAccent,
                                title: "${orderStatus["cancelled"]}",
                                radius: 60,
                                titleStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                SizedBox(height: 30),

                // ✅ flip card
                FlipCard(
                  front: supplierCard(supplier, false),
                  back: supplierCard(supplier, true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget statCard({
    required String title,
    required int value,
    required IconData icon,
    required Color color,
  }) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    color: color.withOpacity(0.85),
    elevation: 6,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
      child: Row(
        children: [
          Icon(icon, size: 48, color: Colors.white),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$value",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(fontSize: 17, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget supplierCard(Map supplier, bool backSide) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.lightBlueAccent.shade100,
      elevation: 10,
      child: Container(
        padding: EdgeInsets.all(24),
        child:
            backSide
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoRow("📍 العنوان", supplier["address"] ?? ""),
                    SizedBox(height: 12),
                    infoRow("📧 الإيميل", supplier["email"] ?? ""),
                    SizedBox(height: 12),
                    infoRow("📞 الهاتف", supplier["phone"] ?? ""),
                  ],
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.business, size: 60, color: Colors.blue.shade900),
                    SizedBox(height: 12),
                    Text(
                      supplier["company_name"] ?? "",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      supplier["contact_person_name"] ?? "",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
        Expanded(
          child: Text(value, style: TextStyle(color: Colors.orange.shade800)),
        ),
      ],
    );
  }
}
