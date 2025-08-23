import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:pro/BottomNavigator/dashBoard/dashboard.dart';
import 'package:pro/BottomNavigator/Medicines/Medicines.dart';
import 'package:pro/BottomNavigator/Medicines/brands-shape_medic/Brand_med.dart';
import 'package:pro/BottomNavigator/Medicines/brands-shape_medic/Shape_med.dart';
import 'package:pro/BottomNavigator/Medicines/talif_medicine.dart';
import 'package:pro/BottomNavigator/Suppliers/Suppliers.dart';
import 'package:pro/BottomNavigator/inventory/show_all_inventory.dart';
import 'package:pro/BottomNavigator/orders/show_order_filter.dart';
import 'package:pro/BottomNavigator/orders/show_order_page.dart';
import 'package:pro/Permission/user_permission.dart';
import 'package:pro/Roles/users.dart';
import 'package:pro/batches/All_batches.dart';
import 'package:pro/cubit/user_cubit.dart';
import 'package:pro/invoices/all_invocies.dart';
import 'package:pro/invoices/paid_invocies.dart';
import 'package:pro/invoices/partilly_paid_invocies.dart';
import 'package:pro/invoices/unpaid_invoices.dart';
import 'package:pro/widget/Global.dart';
import 'package:pro/widget/qr_code.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class King extends StatefulWidget {
  const King({Key? key}) : super(key: key);
  @override
  State<King> createState() => _KingState();
}

class _KingState extends State<King> {
  late ShakeDetectorService _shakeService;
  int _selectedIndex = 2;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _fetchAndShowMedicineInfo(
    BuildContext context,
    String barCode,
  ) async {
    final dio = Dio();
    final url = '$baseUrl/api/show-damaged-medicine';

    try {
      final response = await dio.get(
        url,
        queryParameters: {'bar_code': barCode},
      );
      print(response.data);
      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'success' && data['medicine'] != null) {
          final med = data['medicine'];

          final createdAt = med['created_at']?.split('T')[0] ?? '—';

          showCupertinoDialog(
            context: context,
            builder:
                (_) => CupertinoAlertDialog(
                  title: Text(
                    med['medicine_name'] ?? 'اسم غير معروف',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      children: [
                        _infoRow("الباركود", med['bar_code']),
                        _infoRow("النوع", med['type']),
                        _infoRow("الكمية", med['quantity'].toString()),
                        _infoRow(
                          "حد التنبيه",
                          med['alert_quantity'].toString(),
                        ),
                        _infoRow("سعر البيع", "${med['people_price']} د.ع"),
                        _infoRow("سعر المورد", "${med['supplier_price']} د.ع"),
                        _infoRow("الضريبة", "${med['tax_rate']}%"),
                        _infoRow("تاريخ الإنشاء", createdAt),
                      ],
                    ),
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text("موافق"),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
          );
        } else {
          _showErrorDialog(context, 'لم يتم العثور على بيانات للدواء.');
        }
      } else {
        _showErrorDialog(
          context,
          'فشل في تحميل البيانات (${response.statusCode}).',
        );
      }
    } catch (e) {
      _showErrorDialog(context, 'تعذر الاتصال بالخادم:\n${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    _shakeService = ShakeDetectorService(
      onShake: () {
        _showActionSheet(context);
      },
    );
    _shakeService.start();
  }

  @override
  void dispose() {
    _shakeService.stop();
    super.dispose();
  }

  List<Widget> pages = [
    const dashboard(),
    const Medicines_Category_page(),
    SupplierScreen(),
    OrdersScreen(),
    const All_inventory(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<UserCubit>(context),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _buildDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          automaticallyImplyLeading: false,
          title: Tilt(
            tiltConfig: TiltConfig(
              angle:
                  CupertinoScrollbar
                      .defaultThicknessWhileDragging, // زاوية الميل القصوى
              moveDuration: Duration(milliseconds: 100),
              leaveDuration: Duration(milliseconds: 300),
              enableGestureTouch: true,
              enableGestureSensors: true,
              enableReverse: false,
              sensorFactor: 0.1,
            ),

            child: AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  _tabTitle(_selectedIndex),
                  textStyle: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  speed: Duration(milliseconds: 100),
                ),
              ],
              totalRepeatCount: 1,
              pause: Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
          ),
          leading: IconButton(
            icon: const Icon(CupertinoIcons.settings, color: Colors.black),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                CupertinoIcons.ellipsis_vertical,
                color: Colors.black,
              ),
              onPressed: () => _showActionSheet(context),
            ),
          ],
        ),
        body: pages[_selectedIndex],
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.square_grid_2x2),
              title: const Text("Dashboard"),
              selectedColor: CupertinoColors.activeGreen,
            ),
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.capsule),
              title: const Text("Medicines"),
              selectedColor: CupertinoColors.activeGreen,
            ),
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.person_2_square_stack),
              title: const Text("Suppliers"),
              selectedColor: CupertinoColors.activeGreen,
            ),
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.cart),
              title: const Text("Orders"),
              selectedColor: CupertinoColors.activeGreen,
            ),
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.square_grid_2x2),
              title: const Text("Inventory"),
              selectedColor: CupertinoColors.activeGreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24,
              ),
              color: Colors.green.shade50,
              child: const Text(
                'الإعدادات',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(height: 12),

            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade50.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade100.withOpacity(0.5),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildIOSDrawerItem(
                    icon: CupertinoIcons.person_2_fill,
                    text: 'المستخدمين',
                    iconColor: Colors.green.shade700,
                    textColor: Colors.green.shade900,
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => UserManagementPage(),
                        ),
                      );
                    },
                  ),
                  _buildIOSDrawerItem(
                    icon: CupertinoIcons.lock_shield_fill,
                    text: 'الصلاحيات',
                    iconColor: Colors.green.shade700,
                    textColor: Colors.green.shade900,
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(builder: (_) => User_Permission()),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            // بلوك شكل الدواء والشركة المصنعة
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade50.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade100.withOpacity(0.5),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildIOSDrawerItem(
                    icon: CupertinoIcons.cube_box_fill,
                    text: 'شكل الدواء',
                    iconColor: Colors.green.shade700,
                    textColor: Colors.green.shade900,
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(builder: (_) => MedicineFormsPage()),
                      );
                    },
                  ),
                  _buildIOSDrawerItem(
                    icon: CupertinoIcons.building_2_fill,
                    text: 'الشركة المصنعة',
                    iconColor: Colors.green.shade700,
                    textColor: Colors.green.shade900,
                    onTap: () {
                      Navigator.of(
                        context,
                      ).push(CupertinoPageRoute(builder: (_) => BrandsPage()));
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            // بلوك أدوية تالفة
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade50.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade100.withOpacity(0.5),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: _buildIOSDrawerItem(
                icon: CupertinoIcons.bandage_fill,
                text: 'أدوية تالفة',
                iconColor: Colors.green.shade700,
                textColor: Colors.green.shade900,
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => DamagedMedicinesPage()),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade50.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade100.withOpacity(0.5),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: _buildIOSDrawerItem(
                icon: CupertinoIcons.bandage_fill,
                text: ' جميع الدفعات ',
                iconColor: Colors.green.shade700,
                textColor: Colors.green.shade900,
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(CupertinoPageRoute(builder: (_) => MedicineScreen()));
                },
              ),
            ),
            SizedBox(height: 20),
            _buildExpandableTile(
              icon: CupertinoIcons.paperclip,
              title: 'إدارة الفواتير',
              children: [
                ListTile(
                  leading: Icon(
                    CupertinoIcons.person_2_fill,
                    color: Colors.green,
                  ),
                  title: Text('عرض جميع الفواتير'),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => InvoicesScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.lock_shield_fill,
                    color: Colors.green,
                  ),
                  title: Text('الفواتير الغير مدفوعة '),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => UnpaidInvoicesPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.lock_shield_fill,
                    color: Colors.green,
                  ),
                  title: Text('الفواتير  المدفوعة جزئيا'),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (_) => Paid_Partilly_InvoicesPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.sort_up_circle,
                    color: Colors.green,
                  ),
                  title: Text('الفواتير  المدفوعة '),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => PaidInvoicesPage()),
                    );
                  },
                ),
                // Divider(),
                // CustomIOSDropdown(),
              ],
            ),
            SizedBox(height: 20),
            _buildExpandableTile(
              icon: CupertinoIcons.square_list,
              title: 'طلبات',
              children: [
                ListTile(
                  leading: const Icon(
                    CupertinoIcons.person_crop_circle_badge_checkmark,
                    color: Colors.green,
                  ),
                  title: const Text('حسب المورد'),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => const OrdersResultPage(
                                filterType: 'supplier',
                              ),
                        ),
                      ),
                ),
                ListTile(
                  leading: const Icon(
                    CupertinoIcons.square_favorites_alt,
                    color: Colors.green,
                  ),
                  title: const Text('حسب الحالة'),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  const OrdersResultPage(filterType: 'status'),
                        ),
                      ),
                ),
                ListTile(
                  leading: const Icon(
                    CupertinoIcons.calendar,
                    color: Colors.green,
                  ),
                  title: const Text('حسب التاريخ'),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => const OrdersResultPage(filterType: 'date'),
                        ),
                      ),
                ),
                ListTile(
                  leading: const Icon(
                    CupertinoIcons.search,
                    color: Colors.green,
                  ),
                  title: const Text('بحث'),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  const OrdersResultPage(filterType: 'search'),
                        ),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableTile({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.shade50.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade100.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(icon, color: Colors.green.shade700),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.green.shade900,
            ),
          ),
          iconColor: Colors.green,
          collapsedIconColor: Colors.green.shade700,
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildIOSDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color iconColor = CupertinoColors.systemGrey,
    Color textColor = Colors.black87,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: iconColor, size: 24),
          title: Text(
            text,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          onTap: onTap,
          horizontalTitleGap: 12,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          trailing: const Icon(
            CupertinoIcons.forward,
            size: 18,
            color: CupertinoColors.systemGrey2,
          ),
          hoverColor: Colors.green.shade50, // تأثير عند اللمس أخضر فاتح جداً
        ),
        Divider(
          height: 1,
          thickness: 0.4,
          indent: 60,
          endIndent: 16,
          color: Colors.green.shade100,
        ),
      ],
    );
  }

  String _tabTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Medicines';
      case 2:
        return 'Suppliers';
      case 3:
        return 'Orders';
      case 4:
        return 'showAllInventory';
      default:
        return '';
    }
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      useRootNavigator: true,
      context: context,
      builder:
          (context) => Container(
            child: CupertinoActionSheet(
              title: const Text(
                "الخيارات",
                style: TextStyle(color: Colors.black),
              ),
              message: const Text(
                "اختر أحد الخيارات التالية",
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder:
                            (_) => QRScannerPage(
                              onCodeScanned: (code) async {
                                //  Navigator.pop(context);
                                Future.microtask(() async {
                                  await _fetchAndShowMedicineInfo(
                                    context,
                                    code,
                                  );
                                });
                              },
                            ),
                      ),
                    );
                  },
                  child: const Text(
                    "Scan Medicine",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.of(context).pop(),
                isDestructiveAction: true,
                child: const Text("إغلاق"),
              ),
            ),
          ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            value ?? '—',
            style: const TextStyle(color: CupertinoColors.systemGrey),
          ),
        ],
      ),
    );
  }
}

void _showErrorDialog(BuildContext context, String message) {
  showCupertinoDialog(
    context: context,
    builder:
        (_) => CupertinoAlertDialog(
          title: const Text("خطأ"),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text("موافق"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
  );
}
