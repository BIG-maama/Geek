// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'package:pro/BottomNavigator/orders/order_details.dart';

// class OrdersScreen extends StatefulWidget {
//   @override
//   State<OrdersScreen> createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen>
//     with TickerProviderStateMixin {
//   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
//   late AnimationController _pulseController;
//   late AnimationController _glowController;
//   List<Map<String, dynamic>> orders = [];

//   final List<Map<String, dynamic>> initialOrders = [
//     {
//       "id": 1,
//       "order_number": "ORD-20250630-0001",
//       "order_date": "2024-06-01T00:00:00.000000Z",
//       "status": "pending",
//       "total_amount": 968,
//       "items": [
//         {
//           "medicine_name": "hhslhhvsss",
//           "quantity": 10,
//           "unit_price": "44.00",
//           "total_price": 440,
//         },
//         {
//           "medicine_name": "hhslhhvssss",
//           "quantity": 12,
//           "unit_price": "44.00",
//           "total_price": 528,
//         },
//       ],
//     },
//     {
//       "id": 2,
//       "order_number": "ORD-20250630-0002",
//       "order_date": "2024-06-01T00:00:00.000000Z",
//       "status": "pending",
//       "total_amount": 1144,
//       "items": [
//         {
//           "medicine_name": "hhslhhvsssss",
//           "quantity": 13,
//           "unit_price": "44.00",
//           "total_price": 572,
//         },
//         {
//           "medicine_name": "hhslhhvsssssسسسسس",
//           "quantity": 13,
//           "unit_price": "44.00",
//           "total_price": 572,
//         },
//       ],
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 1),
//     )..repeat(reverse: true);

//     _glowController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 3),
//     )..repeat(reverse: true);

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       for (int i = 0; i < initialOrders.length; i++) {
//         Future.delayed(Duration(milliseconds: 300 * i), () {
//           orders.add(initialOrders[i]);
//           _listKey.currentState?.insertItem(i);
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _pulseController.dispose();
//     _glowController.dispose();
//     super.dispose();
//   }

//   Widget _buildAnimatedItem(
//     BuildContext context,
//     int index,
//     Animation<double> animation,
//   ) {
//     return ScaleTransition(
//       scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
//       child: FadeTransition(
//         opacity: animation,
//         child: SlideTransition(
//           position: Tween<Offset>(
//             begin: Offset(1, 0),
//             end: Offset(0, 0),
//           ).animate(
//             CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
//           ),
//           child: _buildOrderCard(orders[index]),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffeef2f7),
//       appBar: AppBar(
//         title: Text('الطلبات'),
//         backgroundColor: Colors.blueAccent,
//         elevation: 0,
//       ),
//       body: AnimatedList(
//         key: _listKey,
//         padding: const EdgeInsets.all(20),
//         initialItemCount: orders.length,
//         itemBuilder:
//             (context, index, animation) =>
//                 _buildAnimatedItem(context, index, animation),
//       ),
//     );
//   }

//   Widget _buildOrderCard(Map<String, dynamic> order) {
//     return AnimatedBuilder(
//       animation: _glowController,
//       builder: (context, child) {
//         return Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.white,
//                 Colors.blueAccent.withOpacity(
//                   0.1 + 0.1 * sin(_glowController.value * 2 * pi),
//                 ),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.blueAccent.withOpacity(
//                   0.2 + 0.2 * sin(_glowController.value * 2 * pi),
//                 ),
//                 blurRadius: 25,
//                 spreadRadius: 2,
//                 offset: Offset(0, 10),
//               ),
//             ],
//           ),
//           margin: const EdgeInsets.only(bottom: 30),
//           padding: const EdgeInsets.all(22),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _orderRow(
//                 Icons.confirmation_number,
//                 "رقم الطلب",
//                 order['order_number'],
//               ),
//               SizedBox(height: 10),
//               _orderRow(
//                 Icons.calendar_today,
//                 "تاريخ الطلب",
//                 order['order_date'].toString().split("T").first,
//               ),
//               SizedBox(height: 10),
//               _orderRow(
//                 Icons.timelapse,
//                 "الحالة",
//                 _getStatusText(order['status']),
//                 color: Colors.orange,
//               ),
//               SizedBox(height: 10),
//               _orderRow(
//                 Icons.attach_money,
//                 "المبلغ الإجمالي",
//                 "${order['total_amount']} ج.م",
//                 color: Colors.green,
//               ),
//               SizedBox(height: 18),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: ScaleTransition(
//                   scale: Tween(begin: 1.0, end: 1.1).animate(_pulseController),
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => OrderDetailsScreen(orderData: order),
//                         ),
//                       );
//                     },
//                     icon: Icon(Icons.visibility, color: Colors.black),
//                     label: Text(
//                       'عرض التفاصيل',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.greenAccent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 14,
//                       ),
//                       elevation: 10,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _orderRow(IconData icon, String label, String value, {Color? color}) {
//     return Row(
//       children: [
//         Icon(icon, size: 22, color: color ?? Colors.grey[800]),
//         SizedBox(width: 10),
//         Text(
//           "$label: ",
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             textAlign: TextAlign.right,
//             style: TextStyle(
//               color: color ?? Colors.black87,
//               fontSize: 15,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   String _getStatusText(String status) {
//     switch (status) {
//       case 'pending':
//         return 'قيد التنفيذ';
//       case 'completed':
//         return 'مكتمل';
//       case 'cancelled':
//         return 'ملغى';
//       default:
//         return status;
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro/BottomNavigator/orders/add_new_order.dart';
import 'package:pro/BottomNavigator/orders/order_details.dart';
import 'dart:math';
import 'package:pro/widget/Global.dart';

class OrdersScreen extends StatefulWidget {
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late AnimationController _controller;
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;
  final GlobalKey _fabKey = GlobalKey();

  final ValueNotifier<int> flashKey = ValueNotifier(0);
  List<Map<String, dynamic>> orders = [];

  Future<void> fetchOrders() async {
    try {
      print("بدأ تحميل الطلبات...");
      final response = await Dio().get('$baseUrl/api/orders');
      print(response.data);

      if (response.statusCode == 200 && response.data['status'] == true) {
        final List<dynamic> fetchedOrders =
            response.data['data']['orders']['data'];

        for (int i = 0; i < fetchedOrders.length; i++) {
          final order = fetchedOrders[i];
          final orderMap = {
            "id": order["id"],
            "order_number": order["order_number"],
            "order_date": order["order_date"],
            "status": order["status"],
            "total_amount": order["total_amount"],
            "supplier": order["supplier"],
            "items": [], // ملء لاحقًا إذا توفر
          };

          // بدون تأخير هنا
          orders.add(orderMap);
          _listKey.currentState?.insertItem(orders.length - 1);
        }
      }
    } catch (e, s) {
      print("خطأ أثناء جلب الطلبات: $e");
      print("StackTrace: $s");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء تحميل الطلبات')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
    );

    _fabController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 500), () {
        _showCustomTooltip(context);
      });
    });

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    fetchOrders();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _showCustomTooltip(BuildContext context) {
    final overlay = Overlay.of(context);
    final renderBox = _fabKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final targetPosition = renderBox.localToGlobal(Offset.zero);
    final targetSize = renderBox.size;

    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: targetPosition.dx + targetSize.width / 2 - 40,
            top: targetPosition.dy - 40,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('طلب جديد', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 1), () {
      overlayEntry.remove();
    });
  }

  Widget _buildAnimatedItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    final random = Random();
    final dx = (random.nextDouble() * 2 - 1) * 0.5;
    final dy = (random.nextDouble() * 2 - 1) * 0.5;

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(dx, dy),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack)),
      child: ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
        child: FadeTransition(
          opacity: animation,
          child: _buildOrderCard(orders[index]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeef2f7),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : AnimatedList(
                key: _listKey,
                padding: const EdgeInsets.all(20),
                initialItemCount: orders.length,
                itemBuilder:
                    (context, index, animation) =>
                        _buildAnimatedItem(context, index, animation),
              ),
      floatingActionButton: Builder(
        builder:
            (context) => ScaleTransition(
              scale: _fabAnimation,
              child: FloatingActionButton(
                key: _fabKey,
                onPressed: () async {
                  final result = await CustomNavigator.push(
                    context,
                    AddNewOrder(),
                  );
                  if (result == true) {
                    setState(() {
                      _isLoading = true;
                      orders.clear();
                    });
                    await fetchOrders();
                  }
                },

                backgroundColor: Colors.blueAccent,
                child: const Icon(Icons.add, size: 28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
              ),
            ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return ValueListenableBuilder(
      valueListenable: flashKey,
      builder: (context, value, _) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: value == order['id'] ? Colors.yellow.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color:
                    value == order['id']
                        ? Colors.yellow.withOpacity(0.5)
                        : Colors.black.withOpacity(0.1),
                blurRadius: 30,
                spreadRadius: 5,
                offset: Offset(0, 10),
              ),
            ],
          ),
          margin: const EdgeInsets.only(bottom: 30),
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _orderRow(
                Icons.confirmation_number,
                "رقم الطلب",
                order['order_number'],
              ),
              SizedBox(height: 10),
              _orderRow(
                Icons.calendar_today,
                "تاريخ الطلب",
                order['order_date'].toString().split("T").first,
              ),
              SizedBox(height: 10),
              _orderRow(
                Icons.timelapse,
                "الحالة",
                _getStatusText(order['status']),
                color: Colors.orange,
              ),
              SizedBox(height: 10),
              _orderRow(
                Icons.attach_money,
                "المبلغ الإجمالي",
                "${order['total_amount']} ج.م",
                color: Colors.green,
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.delete, color: Colors.white),
                    label: Text(
                      'حذف الطلب',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _deleteOrder(order['id']);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.visibility, color: Colors.black),
                    label: Text(
                      'عرض التفاصيل',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () async {
                      flashKey.value = order['id'];
                      await Future.delayed(Duration(milliseconds: 200));
                      flashKey.value = -1;
                      CustomNavigator.push(
                        context,
                        OrderDetailsScreen(orderId: order['id']),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteOrder(int orderId) {
    showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: Text("تأكيد الحذف"),
            content: Text("هل أنت متأكد أنك تريد حذف هذا الطلب؟"),
            actions: [
              CupertinoDialogAction(
                child: Text("إلغاء"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text("حذف"),
                onPressed: () async {
                  Navigator.of(context).pop();

                  try {
                    final response = await Dio().delete(
                      '$baseUrl/api/orders/$orderId',
                    );

                    if (response.statusCode == 200 &&
                        response.data['status'] == true) {
                      final index = orders.indexWhere(
                        (o) => o['id'] == orderId,
                      );
                      if (index != -1) {
                        orders.removeAt(index);
                        _listKey.currentState?.removeItem(
                          index,
                          (context, animation) =>
                              _buildAnimatedItem(context, index, animation),
                          duration: Duration(milliseconds: 500),
                        );
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم حذف الطلب بنجاح')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('فشل في حذف الطلب')),
                      );
                    }
                  } catch (e) {
                    print("خطأ أثناء حذف الطلب: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('حدث خطأ أثناء حذف الطلب')),
                    );
                  }
                },
              ),
            ],
          ),
    );
  }

  Widget _orderRow(IconData icon, String label, String value, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 22, color: color ?? Colors.grey[800]),
        SizedBox(width: 10),
        Text(
          "$label: ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: color ?? Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'قيد التنفيذ';
      case 'completed':
        return 'مكتمل';
      case 'cancelled':
        return 'ملغى';
      default:
        return status;
    }
  }
}
