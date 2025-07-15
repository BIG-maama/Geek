import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro/BottomNavigator/DashBoard/Dashboard.dart';
import 'package:pro/BottomNavigator/Medicines/Medicines.dart';
import 'package:pro/BottomNavigator/Medicines/brands-shape_medic/Brand_med.dart';
import 'package:pro/BottomNavigator/Medicines/brands-shape_medic/Shape_med.dart';
import 'package:pro/BottomNavigator/Medicines/talif_medicine.dart';
import 'package:pro/BottomNavigator/Suppliers/Suppliers.dart';
import 'package:pro/BottomNavigator/orders/show_order_filter.dart';
import 'package:pro/BottomNavigator/orders/show_order_page.dart';
import 'package:pro/Permission/user_permission.dart';
import 'package:pro/Roles/users.dart';
import 'package:pro/cubit/user_cubit.dart';
import 'package:pro/widget/qr_code.dart';

class King extends StatefulWidget {
  const King({Key? key}) : super(key: key);
  @override
  State<King> createState() => _KingState();
}

class _KingState extends State<King> {
  late CupertinoTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = CupertinoTabController(initialIndex: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        backgroundColor: CupertinoColors.systemGrey6,
        activeColor: CupertinoColors.activeGreen,
        inactiveColor: CupertinoColors.systemGrey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_grid_2x2),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.capsule),
            label: 'Medicines',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2_square_stack),
            label: 'Suppliers',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cart),
            label: 'Orders',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        late final Widget page;

        switch (index) {
          case 0:
            page = const Dashboard();
            break;
          case 1:
            page = const Medicines_Category_page();
            break;
          case 2:
            page = const SuppliersPage();
            break;
          case 3:
            page = OrdersScreen();
            break;
        }
        final GlobalKey<ScaffoldState> localScaffoldKey =
            GlobalKey<ScaffoldState>();
        return CupertinoTabView(
          builder: (context) {
            return BlocProvider.value(
              value: BlocProvider.of<UserCubit>(context),
              child: Scaffold(
                key: localScaffoldKey,
                drawer: _buildDrawer(),
                body: CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    middle: Text(_tabTitle(index)),
                    leading: GestureDetector(
                      onTap: () => localScaffoldKey.currentState?.openDrawer(),
                      child: const Icon(CupertinoIcons.settings),
                    ),
                    trailing: GestureDetector(
                      onTap: () => _showActionSheet(context),
                      child: const Icon(CupertinoIcons.ellipsis_vertical),
                    ),
                  ),
                  child: SafeArea(child: page),
                ),
              ),
            );
          },
        );
      },
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
            _buildExpandableTile(
              icon: CupertinoIcons.paperclip,
              title: 'إدارة الفواتير',
              children: [
                ListTile(
                  leading: Icon(
                    CupertinoIcons.person_2_fill,
                    color: Colors.green,
                  ),
                  title: Text('المستخدمين'),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => UserManagementPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.lock_shield_fill,
                    color: Colors.green,
                  ),
                  title: Text('الصلاحيات'),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => User_Permission()),
                    );
                  },
                ),
                // Divider(),
                // CustomIOSDropdown(),
              ],
            ),
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
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder:
                            (_) => QRScannerPage(
                              onCodeScanned: (code) {
                                _showMedicineInfoDialog(context, code);
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

  void _showMedicineInfoDialog(BuildContext context, String code) {
    showCupertinoDialog(
      context: context,
      builder:
          (_) => CupertinoAlertDialog(
            title: const Text("معلومات الدواء"),
            content: Text("تم مسح الكود بنجاح: $code"),
            actions: [
              CupertinoDialogAction(
                child: const Text("تم"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }
}
