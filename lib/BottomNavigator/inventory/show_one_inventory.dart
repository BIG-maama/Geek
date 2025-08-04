import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';

class InventoryFullScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const InventoryFullScreen({super.key, required this.data});

  @override
  State<InventoryFullScreen> createState() => _InventoryFullScreenState();
}

class _InventoryFullScreenState extends State<InventoryFullScreen> {
  final ScrollController _scrollController = ScrollController();
  late final Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = widget.data['data'] ?? {}; // تأكد من الوصول إلى المفتاح الصحيح
    _setBackgroundByTime();
  }

  late Color backgroundColor;
  late bool isNight;

  void _setBackgroundByTime() {
    final hour = DateTime.now().hour;
    isNight = hour < 6 || hour >= 18;
    backgroundColor = isNight ? Colors.black : Colors.lightBlue.shade100;
  }

  @override
  Widget build(BuildContext context) {
    final createdBy = data['created_by'] as Map<String, dynamic>? ?? {};
    final items = data['items'] as List? ?? [];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: AnimatedTextKit(
                animatedTexts: [
                  FlickerAnimatedText(
                    'تفاصيل الجرد',
                    textStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isNight ? Colors.white : Colors.black,
                    ),
                  ),
                  TyperAnimatedText(
                    'Inventory Details',
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isNight ? Colors.tealAccent : Colors.blue,
                    ),
                    speed: const Duration(milliseconds: 80),
                  ),
                  ColorizeAnimatedText(
                    'مرحبا بك 👋',
                    textStyle: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    colors: [
                      Colors.blue,
                      Colors.teal,
                      Colors.purple,
                      Colors.black,
                    ],
                  ),
                ],
                repeatForever: true,
                isRepeatingAnimation: true,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          offset: const Offset(4, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    width: double.infinity,
                    height: 160,
                    child: Center(
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isNight ? Colors.white : Colors.black,
                        ),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText(data['count_number'] ?? "—"),
                          ],
                          isRepeatingAnimation: false,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _sectionTitle("🗓 معلومات الجرد"),
                  _infoTile("تاريخ الجرد", formatDate(data['count_date'])),
                  _infoTile("الحالة", data['status']),
                  _infoTile("الملاحظات", data['notes'] ?? "لا توجد"),

                  const SizedBox(height: 20),
                  _sectionTitle("👤 معلومات المُنشئ"),
                  _infoTile("الاسم", createdBy['name']),
                  _infoTile("الإيميل", createdBy['email']),
                  _infoTile("الهاتف", createdBy['phone']),
                  _infoTile("الجنس", createdBy['gender']),

                  const SizedBox(height: 20),
                  _sectionTitle("💊 العناصر"),
                  const SizedBox(height: 10),

                  AnimationLimiter(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final medicine = item['medicine'] ?? {};

                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Card(
                                color: Colors.white.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AutoSizeText(
                                        medicine['medicine_name'] ?? '—',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              isNight
                                                  ? Colors.white
                                                  : Colors.black,
                                        ),
                                        //   textDirection: TextDirection.rtl,
                                      ),
                                      _infoTile(
                                        "الاسم العربي",
                                        medicine['arabic_name'],
                                      ),
                                      _infoTile(
                                        "الباركود",
                                        medicine['bar_code'],
                                      ),
                                      _infoTile(
                                        "سعر البيع",
                                        medicine['people_price']?.toString(),
                                      ),
                                      _infoTile(
                                        "سعر المورد",
                                        medicine['supplier_price']?.toString(),
                                      ),
                                      _infoTile(
                                        "الكمية النظامية",
                                        "${item['system_quantity']}",
                                      ),
                                      _infoTile(
                                        "الكمية الفعلية",
                                        "${item['actual_quantity']}",
                                      ),
                                      _infoTile(
                                        "الفرق",
                                        "${item['difference']}",
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isNight ? Colors.white : Colors.black,
        ),
        //  textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget _infoTile(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),

      // ✅ استخدام صحيح هنا
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: TextStyle(
                color: isNight ? Colors.white70 : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value ?? "-",
              style: TextStyle(color: isNight ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(String? isoDate) {
    if (isoDate == null) return "-";
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return "-";
    }
  }
}
