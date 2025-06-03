import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pro/BottomNavigator/Suppliers/supplier_profile.dart';
import 'package:pro/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SupplierProfileAdapter());
  await Hive.openBox<SupplierProfile>('suppliers');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      title: 'Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Almarai'),
      home: king(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// {
//     "status": true,
//     "status_code": 200,
//     "message": "messages.supplier_details_retrieved",
//     "data": {
//         "supplier": {
//             "id": 3,
//             "company_name": "عرصبا",
//             "contact_person_name": "ويللللي",
//             "phone": "9024254375",
//             "email": "ma2151281@gmail.com",
//             "address": "عمان",
//             "bio": null,
//             "is_active": 1,
//             "created_at": "2025-06-01T16:03:07.000000Z",
//             "updated_at": "2025-06-01T16:03:07.000000Z"
//         },
//         "statistics": {
//             "orders": {
//                 "total": 0,
//                 "pending": 0,
//                 "confirmed": 0,
//                 "completed": 0,
//                 "cancelled": 0
//             },
//             "payments": {
//                 "total_paid": 0,
//                 "pending_payments": 0
//             },
//             "orders_summary": {
//                 "last_order_date": null,
//                 "last_payment_date": null
//             },
//             "credit_info": {
//                 "credit_limit": "0.00",
//                 "payment_method": "cash"
//             }
//         },
//         "recent_orders": [],
//         "recent_payments": []
//     }
// }
