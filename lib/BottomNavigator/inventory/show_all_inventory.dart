import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pro/BottomNavigator/inventory/hive_inventory.dart';
import 'package:pro/BottomNavigator/inventory/post_inventory.dart';
import 'package:pro/BottomNavigator/inventory/show_one_inventory.dart';
import 'package:pro/widget/Global.dart';

class All_inventory extends StatefulWidget {
  const All_inventory({Key? key}) : super(key: key);

  @override
  State<All_inventory> createState() => _DashboardState();
}

class _DashboardState extends State<All_inventory>
    with SingleTickerProviderStateMixin {
  List<InventoryCount> inventoryCounts = [];
  List<bool> _isFlipped = [];
  bool _hasNavigated = false;
  final Set<int> _pointerIds = {};
  double _startDragX = 0;
  bool isLoading = true;
  int _tapCount = 0;
  DateTime? _lastTapTime;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await _fetchAndStoreInventoryCounts();
    final inventory = await _loadInventoryFromHive();
    setState(() {
      inventoryCounts = inventory;
      _isFlipped = List.filled(inventory.length, false);
      isLoading = false;
    });
  }

  Future<void> _fetchAndStoreInventoryCounts() async {
    try {
      final response = await Dio().get("$baseUrl/api/inventory-counts");
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> rawList = response.data['data']['inventory_counts'];
        final box = await Hive.openBox<InventoryCount>('inventory_counts');
        await box.clear();
        await box.addAll(rawList.map((e) => InventoryCount.fromJson(e)));
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
    }
  }

  Future<List<InventoryCount>> _loadInventoryFromHive() async {
    final box = await Hive.openBox<InventoryCount>('inventory_counts');
    return box.values.toList();
  }

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
        MaterialPageRoute(builder: (_) => const InventoryRequestPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f3f7),
      body:
          isLoading
              ? const Center(
                child: SpinKitFadingCircle(color: Colors.teal, size: 50.0),
              )
              : GestureDetector(
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
                      final dragDistance = event.position.dx - _startDragX;
                      if (dragDistance.abs() > 50) {
                        _hasNavigated = true;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const InventoryRequestPage(),
                          ),
                        );
                      }
                    }
                  },
                  onPointerUp: (event) => _pointerIds.remove(event.pointer),
                  onPointerCancel: (event) => _pointerIds.remove(event.pointer),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: inventoryCounts.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(
                            () => _isFlipped[index] = !_isFlipped[index],
                          );
                        },
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                          transitionBuilder: (child, animation) {
                            final rotate = Tween(
                              begin: pi,
                              end: 0.0,
                            ).animate(animation);
                            return AnimatedBuilder(
                              animation: rotate,
                              builder: (_, __) {
                                final value = rotate.value;
                                return Transform(
                                  transform: Matrix4.rotationY(value),
                                  alignment: Alignment.center,
                                  child: child,
                                );
                              },
                              child: child,
                            );
                          },
                          child:
                              _isFlipped[index]
                                  ? _buildBackCard(
                                    inventoryCounts[index],
                                    index,
                                  )
                                  : _buildFrontCard(
                                    inventoryCounts[index],
                                    index,
                                  ),
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade300, Colors.blue.shade400],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        height: 180,
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 50,
              lineWidth: 6,
              percent: percent,
              animation: true,
              animationDuration: 600,
              center: Text(
                "${(percent * 100).toStringAsFixed(0)}%",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white30,
              progressColor: Colors.white,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    count.countNumber,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    "${count.countDate.split("T")[0]}",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "عدد الأصناف: ${count.items_count}",
                    style: TextStyle(color: Colors.white70),
                  ),

                  // زر الحالة (قيد التنفيذ أو مكتمل)
                  GestureDetector(
                    onTap:
                        count.status == 'completed'
                            ? null
                            : () {
                              showDialog(
                                context: context,
                                builder:
                                    (_) => AlertDialog(
                                      title: Text('تأكيد'),
                                      content: Text(
                                        'هل تريد تغيير الحالة إلى "مكتمل"؟',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: Text('إلغاء'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              count.status = 'completed';
                                              Hive.box<InventoryCount>(
                                                'inventory_counts',
                                              ).putAt(index, count);
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text('تأكيد'),
                                        ),
                                      ],
                                    ),
                              );
                            },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            count.status == 'in_progress'
                                ? Colors.amber.withOpacity(0.5)
                                : Colors.green.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _getStatusText(count.status),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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
    return Card(
      key: ValueKey(true),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.only(bottom: 16),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [_getStatusColor(count.status), Colors.indigo.shade700],
          ),
        ),
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 140,
                viewportFraction: 0.9,
                enableInfiniteScroll: false,
              ),
              items:
                  count.items.take(3).map((item) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.medicine.name,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            "باركود: ${item.medicine.barCode}",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatColumn(
                                "النظام",
                                item.systemQuantity.toString(),
                              ),
                              _buildStatColumn(
                                "الفعلي",
                                item.actualQuantity.toString(),
                              ),
                              _buildStatColumn(
                                "الفرق",
                                item.difference.toString(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.info_outline, color: Colors.white),
                tooltip: 'عرض التفاصيل',
                onPressed: () async {
                  final id = count.id;
                  final response = await Dio().get(
                    '$baseUrl/api/inventory-counts/$id',
                  );
                  if (response.statusCode == 200) {
                    final data = response.data;
                    print(data);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InventoryFullScreen(data: data),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("فشل في جلب البيانات")),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(title, style: TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  double _calcPercent(InventoryCount count) {
    if (count.items.isEmpty) return 0;
    int total = count.items.length;
    int completed =
        count.items.where((e) => e.systemQuantity == e.actualQuantity).length;
    return completed / total;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'in_progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.grey;
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
}
