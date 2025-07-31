import 'dart:math';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // تحتاج تضيفها في pubspec.yaml
import 'package:percent_indicator/percent_indicator.dart'; // رسم المخططات الدائرية

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);
  @override
  State<dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<dashboard> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> inventoryCounts = [
    {
      "id": 4,
      "count_number": "INV-KZEy538f",
      "count_date": "2024-03-20T00:00:00.000000Z",
      "status": "in_progress",
      "created_by": "hsasa",
      "approved_by": null,
      "items_count": 2,
      "created_at": "2025-07-01 06:49:46",
      "items": [
        {
          "id": 1,
          "medicine": {
            "id": 1,
            "name": "hhslhhvsssssسسسسسس",
            "bar_code": "12121217",
          },
          "system_quantity": 39,
          "actual_quantity": 39,
          "difference": 0,
        },
        {
          "id": 2,
          "medicine": {
            "id": 2,
            "name": "hhslhhvsssssسسس",
            "bar_code": "12121212",
          },
          "system_quantity": 37,
          "actual_quantity": 37,
          "difference": 0,
        },
      ],
    },
  ];

  // لتحكم في بطاقات Flip
  List<bool> _isFlipped = [];

  @override
  void initState() {
    super.initState();
    _isFlipped = List<bool>.filled(inventoryCounts.length, false);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'in_progress':
        return Colors.orange.shade600;
      case 'completed':
        return Colors.green.shade600;
      case 'pending':
        return Colors.grey.shade600;
      default:
        return Colors.blueGrey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'in_progress':
        return 'قيد التنفيذ';
      case 'completed':
        return 'مكتمل';
      case 'pending':
        return 'معلق';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f3f7),
      appBar: AppBar(
        title: Text(
          'لوحة الجرد',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigoAccent,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: inventoryCounts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _isFlipped[index] = !_isFlipped[index];
              });
            },
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 600),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final rotate = Tween(begin: pi, end: 0.0).animate(animation);
                return AnimatedBuilder(
                  animation: rotate,
                  child: child,
                  builder: (context, child) {
                    final isUnder = (ValueKey(_isFlipped[index]) != child?.key);
                    var tilt = (animation.value - 0.5).abs() - 0.5;
                    tilt *= isUnder ? -0.003 : 0.003;
                    final value =
                        isUnder ? min(rotate.value, pi / 2) : rotate.value;
                    return Transform(
                      transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
                      alignment: Alignment.center,
                      child: child,
                    );
                  },
                );
              },
              child:
                  _isFlipped[index]
                      ? _buildBackCard(inventoryCounts[index], index)
                      : _buildFrontCard(inventoryCounts[index], index),
            ),
          );
        },
      ),
    );
  }

  // وجه البطاقة الأمامي
  Widget _buildFrontCard(Map<String, dynamic> count, int index) {
    return Card(
      key: ValueKey(false),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade500, _getStatusColor(count['status'])],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(20),
        height: 180,
        child: Row(
          children: [
            // مخطط دائري للفرق بين النظامي والفعلي
            CircularPercentIndicator(
              radius: 70,
              lineWidth: 8,
              percent: _calcPercent(count),
              center: Text(
                "${(_calcPercent(count) * 100).toStringAsFixed(0)}%",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              progressColor: Colors.white,
              backgroundColor: Colors.white24,
              animation: true,
              animationDuration: 1000,
            ),
            SizedBox(width: 20),
            // بيانات الجرد
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count['count_number'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    count['count_date'].toString().split("T")[0],
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      _getStatusText(count['status']),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "عدد الأصناف: ${count['items_count']}",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // وجه البطاقة الخلفي (Carousel للأصناف)
  Widget _buildBackCard(Map<String, dynamic> count, int index) {
    return Card(
      key: ValueKey(true),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_getStatusColor(count['status']), Colors.indigo.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(16),
        height: 180,
        child: CarouselSlider(
          options: CarouselOptions(
            height: 140,
            viewportFraction: 0.8,
            enlargeCenterPage: true,
            autoPlay: false,
          ),
          items:
              count['items'].map<Widget>((item) {
                double diff = item['difference']?.toDouble() ?? 0;
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['medicine']['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6),
                      Text(
                        "باركود: ${item['medicine']['bar_code']}",
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn(
                            "النظام",
                            item['system_quantity'].toString(),
                          ),
                          _buildStatColumn(
                            "الفعلي",
                            item['actual_quantity'].toString(),
                          ),
                          _buildStatColumn("الفرق", diff.toString()),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(title, style: TextStyle(color: Colors.white70)),
      ],
    );
  }

  // تحسب نسبة التطابق بين الكميات النظامية والفعليّة (لمخطط دائري)
  double _calcPercent(Map<String, dynamic> count) {
    final items = count['items'] as List<dynamic>;
    if (items.isEmpty) return 0.0;

    int totalSystem = 0;
    int totalActual = 0;

    for (var item in items) {
      totalSystem += item['system_quantity'] as int;
      totalActual += item['actual_quantity'] as int;
    }

    if (totalSystem == 0) return 0.0;
    return totalActual / totalSystem;
  }
}
