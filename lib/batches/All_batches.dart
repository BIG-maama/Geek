import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:hive/hive.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pro/batches/hive_save.dart';
import 'package:pro/widget/Global.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({Key? key}) : super(key: key);

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  List<BatchModel> batches = [];
  final Set<int> _tappedItems = {};
  bool _isRefreshing = false;
  bool isLoading = true;

  int selectedFilter = 0; // 0: الكل, 1: البحث, 2: فعالة, 3: غير فعالة
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFromHive();
    _fetchAndStoreData();

    searchController.addListener(() {
      if (selectedFilter == 1) {
        _fetchAndStoreData(query: searchController.text);
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFromHive() async {
    final box = await Hive.openBox<BatchModel>('batches');
    setState(() {
      batches = box.values.toList();
    });
  }

  Future<void> _fetchAndStoreData({String? query, bool? active}) async {
    try {
      Map<String, dynamic> params = {};
      if (query != null && query.isNotEmpty) {
        params['search'] = query;
      }
      if (active != null) {
        params['is_active'] = active ? '1' : '0';
      }

      final response = await Dio().get(
        '$baseUrl/api/medicine-batches',
        queryParameters: params,
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List dataList = response.data['data'];
        final metaJson = response.data['meta'];
        final batchBox = await Hive.openBox<BatchModel>('batches');
        final metaBox = await Hive.openBox<Meta>('meta');

        await batchBox.clear();
        for (var item in dataList) {
          await batchBox.add(BatchModel.fromJson(item));
        }
        await metaBox.put('meta', Meta.fromJson(metaJson));
        setState(() {
          isLoading = false;
        });
        await _loadFromHive(); // انتظر الانتهاء
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await _fetchAndStoreData();
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF6F6),
      body:
          isLoading
              ? const Center(
                child: SpinKitFadingCircle(color: Colors.teal, size: 40.0),
              )
              : SafeArea(
                child: LiquidPullToRefresh(
                  onRefresh: _handleRefresh,
                  animSpeedFactor: 1.5,
                  color: Colors.lightBlueAccent,
                  backgroundColor: Colors.white,
                  child: CustomScrollView(
                    slivers: [
                      _buildAppBar(),

                      SliverToBoxAdapter(child: const SizedBox(height: 16)),
                      SliverToBoxAdapter(child: _buildFilters()),

                      batches.isEmpty
                          ? SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Text(
                                'لا توجد دفعات هنا',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          )
                          : SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final med = batches[index];
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
                                      margin: const EdgeInsets.all(16),
                                      borderRadius: 0,
                                      blur: 20,
                                      border: 0.5,
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
                                                  Colors.white.withOpacity(
                                                    0.08,
                                                  ),
                                                  Colors.lightBlueAccent
                                                      .withOpacity(0.1),
                                                  Colors.white.withOpacity(
                                                    0.05,
                                                  ),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "اسم الدواء: ${med.medicine.name}",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "رقم الدفعة: ${med.batchNumber}",
                                            ),
                                            Text(
                                              "الباركود: ${med.medicine.barcode}",
                                            ),
                                            Text("الكمية: ${med.quantity}"),
                                            Text("السعر: \$${med.unitPrice}"),
                                            Text(
                                              "تاريخ الانتهاء: ${med.expiryDate.substring(0, 10)}",
                                            ),
                                            Row(
                                              children: [
                                                const Text("الحالة: "),
                                                Icon(
                                                  med.isActive
                                                      ? Icons.check_circle
                                                      : Icons.cancel,
                                                  color:
                                                      med.isActive
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
                                      onPlay:
                                          (controller) =>
                                              controller.forward(from: 0),
                                    )
                                    .shake(duration: 600.ms, hz: 4)
                                    .moveY(
                                      begin: _isRefreshing ? -10 : 0,
                                      end: 0,
                                    )
                                    .scaleXY(end: isTapped ? 1.03 : 1.0),
                              );
                            }, childCount: batches.length),
                          ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      floating: true,
      snap: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.3),
              Colors.lightBlueAccent.withOpacity(0.3),
              Colors.white.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedTextKit(
                  repeatForever: true,
                  pause: const Duration(milliseconds: 800),
                  animatedTexts: [
                    RotateAnimatedText(
                      ' جميع دفعات المورد',
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black26,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    RotateAnimatedText(
                      'تحكم كامل بفلترة الدفعات',
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black26,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    RotateAnimatedText(
                      ' جميع الدفعات الموجودة حاليا : ${batches.length}',
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black26,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.medical_services, color: Colors.white, size: 28),
          ],
        ),
      ),
      expandedHeight: 100,
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFilterButton("الكل", 0),
            _buildFilterButton("البحث", 1),
            _buildFilterButton("الفعالة", 2),
            _buildFilterButton("غير فعالة", 3),
          ],
        ),
        if (selectedFilter == 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'ابحث عن اسم الدواء...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFilterButton(String text, int index) {
    final bool isSelected = selectedFilter == index;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.teal : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      onPressed: () async {
        setState(() {
          selectedFilter = index;
          isLoading = true;
        });

        await Future.delayed(Duration.zero);

        switch (index) {
          case 0:
            await _fetchAndStoreData();
            break;
          case 1:
            setState(() {
              isLoading = false;
            });
            return;
          case 2:
            await _fetchAndStoreData(active: true);
            break;
          case 3:
            await _fetchAndStoreData(active: false);
            break;
        }

        setState(() {
          isLoading = false;
        });
      },
      child: Text(text),
    );
  }
}
