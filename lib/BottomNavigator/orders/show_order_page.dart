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
import 'package:flutter/material.dart';
import 'package:pro/BottomNavigator/orders/order_details.dart';
import 'dart:math';

import 'package:pro/widget/Global.dart';

class OrdersScreen extends StatefulWidget {
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late AnimationController _controller;

  final ValueNotifier<int> flashKey = ValueNotifier(0);
  List<Map<String, dynamic>> orders = [];

  final List<Map<String, dynamic>> initialOrders = [
    {
      "id": 1,
      "order_number": "ORD-20250630-0001",
      "order_date": "2024-06-01T00:00:00.000000Z",
      "status": "pending",
      "total_amount": 968,
      "items": [
        {
          "medicine_name": "hhslhhvsss",
          "quantity": 10,
          "unit_price": "44.00",
          "total_price": 440,
        },
        {
          "medicine_name": "hhslhhvssss",
          "quantity": 12,
          "unit_price": "44.00",
          "total_price": 528,
        },
      ],
    },
    {
      "id": 2,
      "order_number": "ORD-20250630-0002",
      "order_date": "2024-06-01T00:00:00.000000Z",
      "status": "pending",
      "total_amount": 1144,
      "items": [
        {
          "medicine_name": "hhslhhvsssss",
          "quantity": 13,
          "unit_price": "44.00",
          "total_price": 572,
        },
        {
          "medicine_name": "hhslhhvsssssسسسسس",
          "quantity": 13,
          "unit_price": "44.00",
          "total_price": 572,
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    Future.delayed(Duration(milliseconds: 300), () {
      for (int i = 0; i < initialOrders.length; i++) {
        Future.delayed(Duration(milliseconds: 300 * i), () {
          orders.add(initialOrders[i]);
          _listKey.currentState?.insertItem(i);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      backgroundColor: Color(0xffeef2f7),
      appBar: AppBar(
        title: Text('الطلبات'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: AnimatedList(
        key: _listKey,
        padding: const EdgeInsets.all(20),
        initialItemCount: orders.length,
        itemBuilder:
            (context, index, animation) =>
                _buildAnimatedItem(context, index, animation),
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
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () async {
                    flashKey.value = order['id'];
                    await Future.delayed(Duration(milliseconds: 200));
                    flashKey.value = -1;
                    CustomNavigator.push(
                      context,
                      OrderDetailsScreen(orderData: order),
                    );
                  },
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: 1.05),
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    builder: (context, scale, child) {
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: ElevatedButton.icon(
                      onPressed: null,
                      icon: Icon(Icons.visibility, color: Colors.black),
                      label: Text(
                        'عرض التفاصيل',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent.withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
