import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pro/BottomNavigator/inventory/hive_inventory.dart';
import 'package:pro/BottomNavigator/inventory/post_inventory.dart';
import 'package:pro/widget/Global.dart';

class All_inventory extends StatefulWidget {
  const All_inventory({Key? key}) : super(key: key);
  @override
  State<All_inventory> createState() => _Dashboard();
}

class _Dashboard extends State<All_inventory>
    with SingleTickerProviderStateMixin {
  int _tapCount = 0;
  DateTime? _lastTapTime;
  void _handleTripleTap() {
    final now = DateTime.now();

    if (_lastTapTime == null ||
        now.difference(_lastTapTime!) > Duration(seconds: 1)) {
      _tapCount = 1;
    } else {
      _tapCount++;
    }

    _lastTapTime = now;

    if (_tapCount == 3) {
      _tapCount = 0;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const InventoryRequestPage()),
      );
    }
  }

  List<InventoryCount> inventoryCounts = [];

  List<bool> _isFlipped = [];
  final Set<int> _pointerIds = {};
  double _startDragX = 0;
  bool _hasNavigated = false;

  Future<void> fetchAndStoreInventoryCounts() async {
    try {
      final response = await Dio().get("$baseUrl/api/inventory-counts");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data["success"] == true) {
          final List<dynamic> rawList = data["data"]["inventory_counts"];

          final List<InventoryCount> inventoryList =
              rawList.map((json) => InventoryCount.fromJson(json)).toList();
          print("عدد العناصر المستلمة: ${inventoryList.length}");

          final box = await Hive.openBox<InventoryCount>('inventory_counts');
          await box.clear(); // مسح البيانات القديمة
          await box.addAll(inventoryList);
        } else {
          print("الاستجابة غير ناجحة من السيرفر");
        }
      } else {
        print("حدث خطأ بالاتصال: ${response.statusCode}");
      }
    } catch (e) {
      print("خطأ أثناء جلب البيانات: $e");
    }
  }

  Future<List<InventoryCount>> loadInventoryFromHive() async {
    final box = await Hive.openBox<InventoryCount>('inventory_counts');
    return box.values.toList();
  }

  @override
  void initState() {
    super.initState();
    _hasNavigated = false;
    fetchAndStoreInventoryCounts().then((_) async {
      final inventory = await loadInventoryFromHive();
      setState(() {
        inventoryCounts = inventory;
        _isFlipped = List<bool>.filled(inventoryCounts.length, false);
      });
    });
    print("عدد العناصر المحملة من Hive: ${inventoryCounts.length}");
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
      body: GestureDetector(
        onTap: _handleTripleTap,
        child: Listener(
          onPointerDown: (event) {
            _pointerIds.add(event.pointer);
            if (_pointerIds.length == 3) {
              _startDragX = event.position.dx;
              _hasNavigated = false;
            }
          },
          onPointerMove: (event) {
            if (_pointerIds.length == 3 && !_hasNavigated) {
              double dragDistance = event.position.dx - _startDragX;
              if (dragDistance.abs() > 50) {
                _hasNavigated = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InventoryRequestPage(),
                  ),
                );
              }
            }
          },
          onPointerUp: (event) {
            _pointerIds.remove(event.pointer);
          },
          onPointerCancel: (event) {
            _pointerIds.remove(event.pointer);
          },
          child: ListView.builder(
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
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                  ) {
                    final rotate = Tween(
                      begin: pi,
                      end: 0.0,
                    ).animate(animation);
                    return AnimatedBuilder(
                      animation: rotate,
                      child: child,
                      builder: (context, child) {
                        final isUnder =
                            (ValueKey(_isFlipped[index]) != child?.key);
                        var tilt = (animation.value - 0.5).abs() - 0.5;
                        tilt *= isUnder ? -0.003 : 0.003;
                        final value =
                            isUnder ? min(rotate.value, pi / 2) : rotate.value;
                        return Transform(
                          transform: Matrix4.rotationY(value)
                            ..setEntry(3, 0, tilt),
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
        ),
      ),
    );
  }

  Widget _buildFrontCard(InventoryCount count, int index) {
    double percent = _calcPercent(count);

    return Card(
      key: ValueKey(false),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent.shade400, Colors.lightBlue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        height: 180,
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 60,
              lineWidth: 8,
              percent: percent,
              center: Text(
                "${(percent * 100).toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              progressColor: Colors.white,
              backgroundColor: Colors.white24,
              animation: true,
              animationDuration: 800,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count.countNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    count.countDate.split("T")[0],
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (count.status == 'in_progress') {
                          count.status = 'completed';
                          // تحديث في Hive إذا كنت تريد حفظ الحالة:
                          Hive.box<InventoryCount>(
                            'inventory_counts',
                          ).putAt(index, count);
                        } else if (count.status == 'completed') {
                          count.status = 'in_progress';
                          Hive.box<InventoryCount>(
                            'inventory_counts',
                          ).putAt(index, count);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            count.status == 'in_progress'
                                ? Colors.cyanAccent.shade100.withOpacity(0.4)
                                : Colors.teal.shade800.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(count.status),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 5),
                  Text(
                    "عدد الأصناف: ${count.items_count}",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackCard(InventoryCount count, int index) {
    int countedItems =
        count.items.where((item) => item.actualQuantity != null).length;

    return Card(
      key: ValueKey(true),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3EF3A4), Color(0xFF0FB5FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        height: 240,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inventory_2_rounded,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(height: 12),
            const Text(
              "تم جرد",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "$countedItems من ${count.items.length} صنف",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 14,
              child: LiquidLinearProgressIndicator(
                value:
                    count.items.isEmpty ? 0 : countedItems / count.items.length,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                borderRadius: 12.0,
                borderWidth: 0.0,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                  label: const Text("تفاصيل الجرد"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    elevation: 4,
                    shadowColor: Colors.black26,
                  ),
                  onPressed: () {
                    print("الانتقال إلى تفاصيل الجرد");
                  },
                )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.3, curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }

  // Widget _buildBackCard(InventoryCount count, int index) {
  //   return Card(
  //     key: ValueKey(true),
  //     elevation: 6,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //     margin: EdgeInsets.only(bottom: 20),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           colors: [_getStatusColor(count.status), Colors.indigo.shade700],
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         ),
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       padding: EdgeInsets.all(16),
  //       height: 180,
  //       child: CarouselSlider(
  //         options: CarouselOptions(
  //           height: 140,
  //           viewportFraction: 0.8,
  //           enlargeCenterPage: true,
  //           autoPlay: false,
  //         ),
  //         items:
  //             count.items.map<Widget>((item) {
  //               return Container(
  //                 decoration: BoxDecoration(
  //                   color: Colors.white24,
  //                   borderRadius: BorderRadius.circular(16),
  //                 ),
  //                 padding: EdgeInsets.all(12),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       item.medicine.name,
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 18,
  //                       ),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                     SizedBox(height: 6),
  //                     Text(
  //                       "باركود: ${item.medicine.barCode}",
  //                       style: TextStyle(color: Colors.white70),
  //                     ),
  //                     SizedBox(height: 10),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: [
  //                         _buildStatColumn(
  //                           "النظام",
  //                           item.systemQuantity.toString(),
  //                         ),
  //                         _buildStatColumn(
  //                           "الفعلي",
  //                           item.actualQuantity.toString(),
  //                         ),
  //                         _buildStatColumn("الفرق", item.difference.toString()),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }).toList(),
  //       ),
  //     ),
  //   );
  // }

  double _calcPercent(InventoryCount count) {
    if (count.items.isEmpty) return 0.0;
    int total = count.items.length;
    int completed =
        count.items
            .where((item) => item.systemQuantity == item.actualQuantity)
            .length;
    return completed / total;
  }
}
