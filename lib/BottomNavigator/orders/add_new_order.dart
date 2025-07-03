import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:pro/widget/Global.dart';

class AddNewOrder extends StatefulWidget {
  @override
  _AddNewOrderState createState() => _AddNewOrderState();
}

class _AddNewOrderState extends State<AddNewOrder> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _orders = [];
  final order_date = TextEditingController();
  final note = TextEditingController();
  final payment_date = TextEditingController();
  final payment_method = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> create_order() async {
    try {
      final response = await Dio().post(
        "$baseUrl/api/orders",
        data: {
          "order_date": order_date.text,
          "note": note.text,
          "payment_date": payment_date.text,
          "payment_method": payment_method.text,
        },
      );
      if (response.statusCode == 201) {
        print(response.data);
      }
    } catch (e) {
      print(e.toString());
    }
  }
  // Future<void> createOrder() async {
  //   setState(() => _isLoading = true);

  //   final orderPayload = {
  //     "supplier_id": 1,
  //     "order_date": "2025-06-20",
  //     "note": "ملاحظات الطلبية المهمة",
  //     "items": [
  //       {
  //         "medicine_id": 1,
  //         "quantity": 10,
  //         "unit_price": 100,
  //         "expiry_date": "2026-03-20",
  //       },
  //       {
  //         "medicine_id": 2,
  //         "quantity": 5,
  //         "unit_price": 100,
  //         "expiry_date": "2026-05-20",
  //       },
  //     ],
  //     "payment": {"payment_date": "2024-03-20", "payment_method": "cash"},
  //   };

  //   try {
  //     final response = await _dio.post(
  //       "$baseUrl/api/orders",
  //       data: orderPayload,
  //     );

  //     if (response.statusCode == 201 && response.data['status'] == true) {
  //       final orderData = response.data['data']['order'];

  //       setState(() {
  //         _orders.insert(0, {
  //           'orderNumber': orderData['order_number'],
  //           'status': orderData['status'],
  //           'date': orderData['order_date'].substring(0, 10),
  //           'items': orderData['items'].length,
  //           'total': orderData['total_amount'].toString(),
  //         });
  //       });

  //       showCupertinoDialog(
  //         context: context,
  //         builder:
  //             (_) => CupertinoAlertDialog(
  //               title: Text("نجاح"),
  //               content: Text("تم إنشاء الطلبية بنجاح"),
  //               actions: [
  //                 CupertinoDialogAction(
  //                   child: Text("موافق"),
  //                   onPressed: () => Navigator.pop(context),
  //                 ),
  //               ],
  //             ),
  //       );
  //     } else {
  //       _showError("فشل إنشاء الطلب");
  //     }
  //   } catch (e) {
  //     _showError("خطأ في الاتصال بالسيرفر");
  //     print("Error: $e");
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  void _showError(String message) {
    showCupertinoDialog(
      context: context,
      builder:
          (_) => CupertinoAlertDialog(
            title: Text("خطأ"),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                child: Text("إغلاق"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDark = brightness == Brightness.dark;
    final bgColor =
        isDark
            ? CupertinoColors.black
            : CupertinoColors.systemGroupedBackground;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('طلباتي'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.add),
              onPressed: () {},
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.refresh),
              onPressed: () {},
            ),
          ],
        ),
      ),
      backgroundColor: bgColor,
      child: SafeArea(
        child:
            _isLoading
                ? Center(child: CupertinoActivityIndicator())
                : _orders.isEmpty
                ? Center(child: Text("لا توجد طلبات حالياً"))
                : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: CupertinoListTile(
                        leading: Icon(
                          CupertinoIcons.cube_box,
                          color: CupertinoColors.activeBlue,
                        ),
                        title: Text(
                          order['orderNumber'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("الحالة: ${order['status']}"),
                            Text("عدد المنتجات: ${order['items']}"),
                            Text("المبلغ: ${order['total']} د.ك"),
                            Text("التاريخ: ${order['date']}"),
                          ],
                        ),
                        trailing: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(CupertinoIcons.forward, size: 20),
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}















// http://localhost:8000/api/orders
// {
//     "supplier_id": 1,
//     "order_date": "2025-06-20",
//     "note":"ملاحظات الطلبية المهمة",
//     "items": [
//         {
//             "medicine_id": 1,
//             "quantity": 3,
//             "unit_price": 100,
//             "expiry_date": "2026-03-20"
//         },
//         {
//             "medicine_id": 3,
//             "quantity": 20,
//             "unit_price": 100,
//             "expiry_date": "2026-05-20"
//         }
//     ],
//     "payment": {
//         "payment_date": "2024-03-20",
//         "payment_method": "cash"
        
//     }
// }
// {
//     "status": true,
//     "status_code": 201,
//     "message": "تم إنشاء الطلبية بنجاح",
//     "data": {
//         "order": {
//             "id": 1,
//             "order_number": "ORD-20250626-0001",
//             "order_date": "2025-06-20T00:00:00.000000Z",
//             "status": "pending",
//             "items": [
//                 {
//                     "medicine_id": 1,
//                     "medicine_name": "hhslhhvssfwسswssssswzwss",
//                     "quantity": 3,
//                     "unit_price": 100,
//                     "total_price": 300,
//                     "expiry_date": "2026-03-20",
//                     "default_supplier_price": "44.00"
//                 },
//                 {
//                     "medicine_id": 3,
//                     "medicine_name": "hhslhhvsss",
//                     "quantity": 20,
//                     "unit_price": 100,
//                     "total_price": 2000,
//                     "expiry_date": "2026-05-20",
//                     "default_supplier_price": "44.00"
//                 }
//             ],
//             "total_amount": 2300
//         }
//     }
// }