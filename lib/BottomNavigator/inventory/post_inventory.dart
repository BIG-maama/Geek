import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:pro/BottomNavigator/Medicines/medic_&_catg_info.dart';
import 'package:pro/widget/Global.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';

class InventoryRequestPage extends StatefulWidget {
  const InventoryRequestPage({Key? key}) : super(key: key);

  @override
  State<InventoryRequestPage> createState() => _InventoryRequestPageState();
}

class _InventoryRequestPageState extends State<InventoryRequestPage> {
  final TextEditingController _notesController = TextEditingController(
    text: "جرد دوري شهري",
  );
  Set<int> _selectedMedicineIds = {};

  List<MedicInfo> _medicines = [];
  ButtonState _buttonState = ButtonState.idle;
  late ConfettiController _confettiController;
  TextEditingController noties = TextEditingController();
  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _loadMedicines();
  }

  void _loadMedicines() {
    final box = Hive.box<MedicInfo>('medics');
    print("✅ عدد الأدوية: ${box.length}");
    for (var m in box.values) {
      print("🔍 دواء: ${m.name} - الكمية: ${m.quantity}");
    }
    setState(() {
      _medicines = box.values.toList();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _submitInventory() async {
    //   setState(() => _buttonState = ButtonState.loading);
    if (_selectedMedicineIds.isEmpty) {
      BotToast.showText(text: "لم يتم اختيار أي دواء لإجراء الجرد!");
      setState(() => _buttonState = ButtonState.fail);
      return;
    }

    try {
      final dio = Dio();
      final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final List<Map<String, dynamic>> items =
          _medicines
              .where(
                (m) => _selectedMedicineIds.contains(m.id),
              ) // ✅ فقط المختارة
              .map((medicine) {
                return {
                  "medicine_id": medicine.id,
                  "actual_quantity": medicine.quantity,
                  "notes": _notesController.text,
                };
              })
              .toList();

      final dataToSend = {
        "count_date": currentDate,
        "notes": _notesController.text,
        "items": items,
      };

      print("📦 إرسال البيانات:");
      print(dataToSend);

      final response = await dio.post(
        '$baseUrl/api/inventory-counts',
        data: dataToSend,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ تم الإرسال بنجاح: ${response.data}");
        _confettiController.play();
        setState(() => _buttonState = ButtonState.success);
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context);
      } else {
        print("❌ فشل الإرسال: ${response.statusCode}");
        BotToast.showText(text: "فشل الإرسال، تحقق من الاتصال أو البيانات");
        setState(() => _buttonState = ButtonState.fail);
        return;
      }
    } catch (e) {
      print("🚨 حدث خطأ: $e");
      BotToast.showText(text: "حدث خطأ أثناء الإرسال: $e");
      setState(() => _buttonState = ButtonState.fail);
      return;
    }

    setState(() => _buttonState = ButtonState.idle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'طلب جرد جديد 📦',
              textStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          isRepeatingAnimation: false,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.indigo,
        animatedIcon: AnimatedIcons.menu_close,
        overlayOpacity: 0.1,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.refresh, color: Colors.white),
            label: 'تحديث',
            backgroundColor: Colors.blueAccent,
            onTap: _loadMedicines,
          ),
          SpeedDialChild(
            child: const Icon(Icons.help_outline, color: Colors.white),
            label: 'مساعدة',
            backgroundColor: Colors.green,
            onTap:
                () => showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text("مساعدة"),
                        content: const Text(
                          "هذه الشاشة تتيح لك تقديم طلب جرد الأدوية.",
                        ),
                      ),
                ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ملاحظات الجرد:",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "أدخل ملاحظات...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 320,
                    child:
                        _medicines.isEmpty
                            ? Shimmer.fromColors(
                              baseColor: Colors.green.shade300,
                              highlightColor: Colors.green.shade100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder:
                                    (_, index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                      ),
                                      child: Container(
                                        width: 250,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                    ),
                              ),
                            )
                            : CarouselSlider(
                              options: CarouselOptions(
                                height: 320,
                                enlargeCenterPage: true,
                                autoPlay: false,
                                viewportFraction: 0.85,
                              ),
                              items:
                                  _medicines.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final medicine = entry.value;
                                    final quantity =
                                        int.tryParse(medicine.quantity) ?? 0;
                                    final percent = min(quantity / 50, 1.0);
                                    final isSelected = _selectedMedicineIds
                                        .contains(medicine.id);
                                    final TextEditingController
                                    _quantityController = TextEditingController(
                                      text: medicine.quantity,
                                    );
                                    final TextEditingController
                                    _noteController = TextEditingController(
                                      text: medicine.name,
                                    );

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isSelected) {
                                            _selectedMedicineIds.remove(
                                              medicine.id,
                                            );
                                          } else {
                                            _selectedMedicineIds.add(
                                              medicine.id,
                                            );
                                          }
                                        });
                                      },
                                      child: Opacity(
                                        opacity: isSelected ? 1.0 : 0.4,
                                        child: Tilt(
                                          tiltConfig: const TiltConfig(
                                            angle: 10,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.indigo,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "دواء: ${medicine.name}",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                SizedBox(
                                                  width: 100,
                                                  height: 100,
                                                  child: LiquidCircularProgressIndicator(
                                                    value: percent,
                                                    valueColor:
                                                        const AlwaysStoppedAnimation(
                                                          Colors.white,
                                                        ),
                                                    backgroundColor:
                                                        Colors.white24,
                                                    borderColor: Colors.white,
                                                    borderWidth: 2,
                                                    direction: Axis.vertical,
                                                    center: Text(
                                                      "${(percent * 100).round()}%",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                TextField(
                                                  controller:
                                                      _quantityController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                        labelText: 'الكمية',
                                                        labelStyle: TextStyle(
                                                          color: Colors.white70,
                                                        ),
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                  onChanged: (val) {
                                                    medicine.quantity = val;
                                                    Hive.box<MedicInfo>(
                                                      'medics',
                                                    ).putAt(index, medicine);
                                                  },
                                                ),
                                                const SizedBox(height: 8),
                                                TextField(
                                                  controller: _noteController,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                        labelText: 'ملاحظة',
                                                        labelStyle: TextStyle(
                                                          color: Colors.white70,
                                                        ),
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                  onChanged: (val) {
                                                    noties =
                                                        val as TextEditingController;
                                                    Hive.box<MedicInfo>(
                                                      'medics',
                                                    ).putAt(index, medicine);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ).animate().fade(duration: 600.ms).slideY(begin: 0.2),
                                      ),
                                    );
                                  }).toList(),
                            ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ShakeWidget(
                      autoPlay: _buttonState == ButtonState.fail,
                      shakeConstant: ShakeHorizontalConstant1(),
                      child: ProgressButton.icon(
                        iconedButtons: {
                          ButtonState.idle: IconedButton(
                            text: "إرسال",
                            icon: const Icon(Icons.send, color: Colors.white),
                            color: Colors.indigo,
                          ),
                          ButtonState.loading: IconedButton(
                            text: "...",
                            color: Colors.indigo.shade200,
                          ),
                          ButtonState.success: IconedButton(
                            text: "تم الإرسال!",
                            icon: const Icon(Icons.check, color: Colors.white),
                            color: Colors.green,
                          ),
                          ButtonState.fail: IconedButton(
                            text: "فشل",
                            icon: const Icon(Icons.cancel, color: Colors.white),
                            color: Colors.red,
                          ),
                        },
                        onPressed:
                            _buttonState == ButtonState.idle
                                ? _submitInventory
                                : null,
                        state: _buttonState,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 25,
              maxBlastForce: 20,
              minBlastForce: 8,
              emissionFrequency: 0.05,
            ),
          ),
        ],
      ),
    );
  }
}
