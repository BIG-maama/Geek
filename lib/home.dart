import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro/BottomNavigator/DashBoard/Dashboard.dart';
import 'package:pro/BottomNavigator/Medicines/Medicines.dart';
import 'package:pro/BottomNavigator/Medicines/brands-shape_medic/Brand_med.dart';
import 'package:pro/BottomNavigator/Medicines/brands-shape_medic/Shape_med.dart';
import 'package:pro/BottomNavigator/Medicines/talif_medicine.dart';
import 'package:pro/BottomNavigator/Suppliers/Suppliers.dart';
import 'package:pro/BottomNavigator/orders/show_order_page.dart';
import 'package:pro/Permission/user_permission.dart';
import 'package:pro/Reigster/login_page.dart';
import 'package:pro/Roles/users.dart';
import 'package:pro/cubit/user_cubit.dart';
import 'package:pro/cubit/user_state.dart';
import 'package:pro/widget/Global.dart';
import 'package:pro/widget/qr_code.dart';

// class King extends StatefulWidget {
//   const King({Key? key}) : super(key: key);

//   @override
//   State<King> createState() => _King();
// }

// class _King extends State<King> {
//   int currentIndex = 0;

//   final List<Widget> pages = [
//     const Dashboard(),
//     const Medicines_Category_page(),
//     const SuppliersPage(),
//     OrdersPage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<UserCubit, UserState>(
//       listener: (context, state) {
//         if (state is UserFailure) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(state.message)));
//         }
//         if (state is UserSuccess) {
//           CustomNavigator.push(
//             context,
//             BlocProvider.value(
//               value: context.read<UserCubit>(),
//               child: LoginScreen(),
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         final cubit = context.read<UserCubit>();
//         return Scaffold(
//           appBar: AppBar(title: const Text("hello")),
//           drawer: Drawer(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   DrawerHeader(
//                     decoration: BoxDecoration(color: Colors.green.shade100),
//                     child: const SizedBox(), // placeholder
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(29),
//                     child: Wrap(
//                       runSpacing: 15,
//                       children: [
//                         CupertinoExpansionTileAnimated(
//                           leading: const Icon(CupertinoIcons.settings),
//                           title: const Text("إعدادات المستخدم"),
//                           children: [
//                             CupertinoButton(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                               ),
//                               color: CupertinoColors.systemGrey5,
//                               child: const Text("المستخدمين"),
//                               onPressed: () {
//                                 CustomNavigator.push(
//                                   context,
//                                   UserManagementPage(),
//                                 );
//                               },
//                             ),
//                             CupertinoButton(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                               ),
//                               color: CupertinoColors.systemGrey5,
//                               child: const Text("الصلاحيات"),
//                               onPressed: () {
//                                 CustomNavigator.push(
//                                   context,
//                                   const User_Permission(),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                         const Divider(),
//                         CupertinoExpansionTileAnimated(
//                           leading: const Icon(CupertinoIcons.settings),
//                           title: const Text("اعدادات الدواء "),
//                           children: [
//                             CupertinoButton(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                               ),
//                               color: CupertinoColors.systemGrey5,
//                               child: const Text("شكل الدواء"),
//                               onPressed: () {
//                                 CustomNavigator.push(
//                                   context,
//                                   MedicineFormsPage(),
//                                 );
//                               },
//                             ),
//                             CupertinoButton(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                               ),
//                               color: CupertinoColors.systemGrey5,
//                               child: const Text("الشركة المصنعة للدواء"),
//                               onPressed: () {
//                                 CustomNavigator.push(context, BrandsPage());
//                               },
//                             ),
//                           ],
//                         ),
//                         const Divider(),
//                         SizedBox(
//                           width: double.infinity,
//                           child: IOSButtons.iconButton(
//                             icon: CupertinoIcons.cloud_fog,
//                             text: 'أدوية تالفة',
//                             onPressed: () {
//                               CustomNavigator.push(
//                                 context,
//                                 DamagedMedicinesPage(),
//                               );
//                             },
//                           ),
//                         ),
//                         const Divider(),
//                         ListTile(
//                           leading: const Icon(Icons.logout_outlined),
//                           title: const Text("log out"),
//                           onTap:
//                               state is UserLoading
//                                   ? null
//                                   : () => cubit.signOut(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           body: pages[currentIndex],
//           bottomNavigationBar: BottomNavigationBar(
//             currentIndex: currentIndex,
//             onTap: (index) => setState(() => currentIndex = index),
//             selectedItemColor: Colors.green, // لون العنصر المختار
//             unselectedItemColor: Colors.grey, // لون العناصر غير المختارة
//             backgroundColor: Colors.white, // خلفية الشريط
//             items: const [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.dashboard_rounded),
//                 label: "Dashboard",
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.medical_services_outlined),
//                 label: "Medicines",
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.support_agent_rounded),
//                 label: "Suppliers",
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.add_circle_rounded),
//                 label: "Order",
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
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

        return CupertinoTabView(
          builder: (context) {
            return BlocProvider.value(
              value: BlocProvider.of<UserCubit>(context),
              child: CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  middle: Text(_tabTitle(index)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (index == 1 || index == 0 || index == 2)
                        GestureDetector(
                          onTap: () {
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

                          child: const Icon(CupertinoIcons.camera),
                        ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => _openDrawer(context),
                        child: const Icon(CupertinoIcons.settings),
                      ),
                    ],
                  ),
                ),
                child: SafeArea(child: page),
              ),
            );
          },
        );
      },
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

  void _openDrawer(BuildContext context) {
    showCupertinoModalPopup(
      useRootNavigator: true,
      context: context,
      builder:
          (context) => CupertinoActionSheet(
            title: const Text("الإعدادات"),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(builder: (_) => UserManagementPage()),
                  );
                },
                child: const Text("المستخدمين"),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(CupertinoPageRoute(builder: (_) => User_Permission()));
                },
                child: const Text("الصلاحيات"),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(builder: (_) => MedicineFormsPage()),
                  );
                },
                child: const Text("شكل الدواء"),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(CupertinoPageRoute(builder: (_) => BrandsPage()));
                },
                child: const Text("الشركة المصنعة"),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(builder: (_) => DamagedMedicinesPage()),
                  );
                },
                child: const Text("أدوية تالفة"),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              isDestructiveAction: true,
              child: const Text("إغلاق"),
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
