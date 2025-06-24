import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro/BottomNavigator/DashBoard/Dashboard.dart';
import 'package:pro/BottomNavigator/Medicines/Brand_med.dart';
import 'package:pro/BottomNavigator/Medicines/Medicines.dart';
import 'package:pro/BottomNavigator/Medicines/Shape_med.dart';
import 'package:pro/BottomNavigator/Suppliers/Suppliers.dart';
import 'package:pro/Permission/user_permission.dart';
import 'package:pro/Reigster/login_page.dart';
import 'package:pro/Roles/users.dart';
import 'package:pro/cubit/user_cubit.dart';
import 'package:pro/cubit/user_state.dart';
import 'package:pro/widget/Global.dart';

class king extends StatefulWidget {
  const king({Key? key}) : super(key: key);
  @override
  State<king> createState() => _king();
}

class _king extends State<king> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    Dashboard(),
    Medicines_Category_page(),
    SuppliersPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is UserSuccess)
          //      Future.microtask(() {
          CustomNavigator.push(
            context,
            BlocProvider.value(
              value: context.read<UserCubit>(),
              child: LoginScreen(),
            ),
          );
        // });
        //  }
      },
      builder: (context, state) {
        final cubit = context.read<UserCubit>();
        return Scaffold(
          appBar: AppBar(title: Text("hello")),
          drawer: Drawer(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.green.shade100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   "name : ${UserData.currentUser!.name}",
                        //   style: TextStyle(
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // SizedBox(height: 5),
                        // Text(
                        //   "email : ${UserData.currentUser!.email}",
                        //   style: TextStyle(fontSize: 14),
                        // ),
                        // SizedBox(height: 5),
                        // Text(
                        //   "phone : ${UserData.currentUser!.phone}",
                        //   style: TextStyle(fontSize: 14),
                        // ),
                        // SizedBox(height: 5),
                        // Text(
                        //   "gender : ${UserData.currentUser!.gender}",
                        //   style: TextStyle(fontSize: 14),
                        // ),
                        // SizedBox(height: 5),
                        // Text(
                        //   "created_at : ${UserData.currentUser!.date}",
                        //   style: TextStyle(fontSize: 14),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(29),
                    child: Wrap(
                      runSpacing: 15,
                      children: [
                        CupertinoExpansionTileAnimated(
                          leading: const Icon(CupertinoIcons.settings),
                          title: const Text("إعدادات المستخدم"),
                          children: [
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              color: CupertinoColors.systemGrey5,
                              child: const Text("المستخدمين"),
                              onPressed: () {
                                CustomNavigator.push(
                                  context,
                                  UserManagementPage(),
                                );
                              },
                            ),
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              color: CupertinoColors.systemGrey5,
                              child: const Text("الصلاحيات"),
                              onPressed: () {
                                CustomNavigator.push(
                                  context,
                                  User_Permission(),
                                );
                              },
                            ),
                          ],
                        ),
                        Divider(),
                        CupertinoExpansionTileAnimated(
                          leading: const Icon(CupertinoIcons.settings),
                          title: const Text("اعدادات الدواء "),
                          children: [
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              color: CupertinoColors.systemGrey5,
                              child: const Text("شكل الدواء"),
                              onPressed: () {
                                CustomNavigator.push(
                                  context,
                                  MedicineFormsPage(),
                                );
                              },
                            ),
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              color: CupertinoColors.systemGrey5,
                              child: const Text("الشركة المصنعة للدواء"),
                              onPressed: () {
                                CustomNavigator.push(context, BrandsPage());
                              },
                            ),
                          ],
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.logout_outlined),
                          title: Text("log out"),
                          onTap:
                              state is UserLoading
                                  ? null
                                  : () => cubit.signOut(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: pages[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => setState(() => currentIndex = index),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                label: "Dashborad",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.medical_services_outlined),
                label: "Medicines",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.support_agent_rounded),
                label: "Suppliers",
              ),
            ],
          ),
        );
      },
    );
  }
}
