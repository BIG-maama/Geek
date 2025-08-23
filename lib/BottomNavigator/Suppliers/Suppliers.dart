import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pro/BottomNavigator/Suppliers/addNewSuppplier.dart';
import 'package:pro/BottomNavigator/Suppliers/supplier_info.dart';
import 'package:pro/BottomNavigator/Suppliers/supplier_profile.dart';
import 'package:pro/BottomNavigator/Suppliers/supplier_purchase.dart';
import 'package:pro/widget/Global.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SupplierScreen extends StatefulWidget {
  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  bool isLoading = true;
  List<Supplier> suppliers = [];
  Set<int> _tappedItems = {};

  @override
  void initState() {
    super.initState();
    _fetchSuppliers();
  }

  Future<void> _fetchSuppliers() async {
    setState(() => isLoading = true);

    final box = Hive.box<Supplier>('suppliers');

    try {
      final response = await Dio().get('$baseUrl/api/suppliers');

      if (response.statusCode == 200) {
        if (response.data is Map && response.data.containsKey('data')) {
          final List<dynamic> rawList = response.data['data'];

          final List<Supplier> fetchedSuppliers =
              rawList.map((e) => Supplier.fromJson(e)).toList();

          // 🗑️ امسح القديم من Hive وخزن الجديد
          await box.clear();
          await box.addAll(fetchedSuppliers);

          setState(() {
            suppliers = fetchedSuppliers;
            isLoading = false;
          });
          return;
        }
      }

      // في حال الريسبونس مو صحيح → جيب من Hive
      setState(() {
        suppliers = box.values.toList();
        isLoading = false;
      });
    } catch (e) {
      // 🚫 إذا ما في إنترنت أو صار خطأ → اعرض البيانات من Hive
      setState(() {
        suppliers = box.values.toList();
        isLoading = false;
      });
    }
  }

  Future<void> _deactivateSupplier(int index) async {
    final supplier = suppliers[index];
    try {
      final response = await Dio().put(
        '$baseUrl/api/dis-active-supplier/${supplier.id}',
      );

      if (response.statusCode == 200) {
        setState(() {
          suppliers[index] = Supplier(
            id: supplier.id,
            companyName: supplier.companyName,
            contactPersonName: supplier.contactPersonName,
            phone: supplier.phone,
            email: supplier.email,
            isActive: 0,
            unpaidPurchases: supplier.unpaidPurchases,
          );
        });
        _showSnackBar('🚫 تم تعطيل ${supplier.companyName}', Colors.red);
      }
    } catch (e) {
      _showSnackBar('❌ خطأ في تعطيل المورد', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  Widget _buildSupplierCard(Supplier supplier, int index) {
    bool isActive = supplier.isActive == 1;
    bool isTapped = _tappedItems.contains(index);

    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Slidable(
            direction: Axis.horizontal,
            key: ValueKey(supplier.id),
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                if (isActive)
                  SlidableAction(
                    onPressed: (_) => _deactivateSupplier(index),
                    backgroundColor: Colors.red.shade600,
                    icon: Icons.block,
                    label: 'تعطيل',
                  ),
                SlidableAction(
                  onPressed: (_) {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: SupplierScreenDetailes(supplier.id),
                      ),
                    );
                  },
                  backgroundColor: Colors.blueGrey,
                  icon: Icons.info_outline,
                  label: 'التفاصيل',
                ),
                SlidableAction(
                  onPressed: (_) {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: SupplierPurchasesScreen(supplier.id),
                      ),
                    );
                  },
                  backgroundColor: Colors.orange,
                  icon: Icons.shopping_cart,
                  label: 'المشتريات',
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isTapped) {
                    _tappedItems.remove(index);
                  } else {
                    _tappedItems.add(index);
                  }
                });
              },
              child: Center(
                child: Stack(
                      children: [
                        Card(
                          color: Colors.white.withOpacity(isActive ? 0.9 : 0.3),
                          elevation: isActive ? 8 : 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Opacity(
                                opacity: isActive ? 1.0 : 0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "🏢 ${supplier.companyName}",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            isActive
                                                ? Colors.black
                                                : Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "👤 ${supplier.contactPersonName}",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color:
                                            isActive
                                                ? Colors.black87
                                                : Colors.grey.shade600,
                                      ),
                                    ),
                                    Text(
                                      "📞 ${supplier.phone}",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color:
                                            isActive
                                                ? Colors.black87
                                                : Colors.grey.shade600,
                                      ),
                                    ),
                                    Text(
                                      "✉️ ${supplier.email}",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color:
                                            isActive
                                                ? Colors.black87
                                                : Colors.grey.shade600,
                                      ),
                                    ),
                                    Text(
                                      "📦 المشتريات غير المدفوعة: ${supplier.unpaidPurchases}",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color:
                                            isActive
                                                ? Colors.black87
                                                : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color:
                                      isActive
                                          ? Colors.green
                                          : Colors.red.shade300,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              )
                              .animate(
                                onPlay: (controller) => controller.repeat(),
                              )
                              .scaleXY(
                                begin: 1,
                                end: isActive ? 1.4 : 1.0,
                                duration: 800.ms,
                                curve: Curves.easeInOut,
                              )
                              .fadeIn(duration: 300.ms),
                        ),
                      ],
                    )
                    .animate(target: isTapped ? 1 : 0)
                    .shake(duration: 600.ms, hz: 4)
                    .scaleXY(end: isTapped ? 1.03 : 1.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : suppliers.isEmpty
              ? const Center(child: Text("لا توجد بيانات"))
              : RefreshIndicator(
                onRefresh: _fetchSuppliers,
                child: AnimationLimiter(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: suppliers.length,
                    itemBuilder: (context, index) {
                      return _buildSupplierCard(suppliers[index], index);
                    },
                  ),
                ),
              ),
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add, color: Colors.white),
            backgroundColor: Colors.green,
            label: 'إضافة مورد',
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: AddSupplierPage(),
                ),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.refresh, color: Colors.white),
            backgroundColor: Colors.orange,
            label: 'تحديث',
            onTap: _fetchSuppliers,
          ),
        ],
      ),
    );
  }
}
