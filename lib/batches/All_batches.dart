import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({Key? key}) : super(key: key);

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  List<Map<String, dynamic>> data = [
    {
      "batch_number": "12332165",
      "quantity": 20,
      "expiry_date": "2022-07-13T00:00:00.000000Z",
      "unit_price": "20.00",
      "is_active": true,
      "medicine": {"name": "Setaffahs", "barcode": "12121212"},
    },
    {
      "batch_number": "852963741",
      "quantity": 15,
      "expiry_date": "2023-11-25T00:00:00.000000Z",
      "unit_price": "17.50",
      "is_active": false,
      "medicine": {"name": "Setaffahss", "barcode": "12121216"},
    },
  ];

  final Set<int> _tappedItems = {};
  bool _isRefreshing = false;

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF6F6),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            const SizedBox(height: 16),
            Expanded(
              child: LiquidPullToRefresh(
                onRefresh: _handleRefresh,
                animSpeedFactor: 1.5,
                color: Colors.lightBlueAccent,
                backgroundColor: Colors.white,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final med = data[index];
                    final isTapped = _tappedItems.contains(index);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_tappedItems.contains(index)) {
                            _tappedItems.remove(index);
                          } else {
                            _tappedItems.add(index);
                          }
                        });
                      },
                      child: GlassmorphicContainer(
                            width: double.infinity,
                            height: 180,
                            margin: const EdgeInsets.only(bottom: 20),
                            borderRadius: 20,
                            blur: 20,
                            border: 1,
                            alignment: Alignment.center,
                            linearGradient: LinearGradient(
                              colors:
                                  isTapped
                                      ? [
                                        Colors.green.withOpacity(0.3),
                                        Colors.blue.withOpacity(0.3),
                                        Colors.white.withOpacity(0.3),
                                      ]
                                      : [
                                        Colors.white.withOpacity(0.08),
                                        Colors.lightBlueAccent.withOpacity(0.1),
                                        Colors.white.withOpacity(0.05),
                                      ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderGradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.05),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "اسم الدواء: ${med['medicine']['name']}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text("رقم الدفعة: ${med['batch_number']}"),
                                  Text(
                                    "الباركود: ${med['medicine']['barcode']}",
                                  ),
                                  Text("الكمية: ${med['quantity']}"),
                                  Text("السعر: \$${med['unit_price']}"),
                                  Text(
                                    "تاريخ الانتهاء: ${med['expiry_date'].substring(0, 10)}",
                                  ),
                                  Row(
                                    children: [
                                      const Text("الحالة: "),
                                      Icon(
                                        med['is_active']
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color:
                                            med['is_active']
                                                ? Colors.green
                                                : Colors.red,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                          .animate(
                            target: isTapped || _isRefreshing ? 1 : 0,
                            onPlay: (controller) => controller.forward(from: 0),
                          )
                          .shake(duration: 600.ms, hz: 4)
                          .moveY(begin: _isRefreshing ? -10 : 0, end: 0)
                          .scaleXY(end: isTapped ? 1.03 : 1.0),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00B4D8), Color(0xFF90E0EF), Color(0xFFCAF0F8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedTextKit(
            repeatForever: true,
            pause: const Duration(milliseconds: 500),
            animatedTexts: [
              RotateAnimatedText(
                'مخزون الأدوية',
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              RotateAnimatedText(
                'دفعات قيد التحقق',
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              RotateAnimatedText(
                'تحكم كامل بالمستودع',
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Icon(Icons.medical_services, color: Colors.white, size: 28),
        ],
      ),
    );
  }
}
