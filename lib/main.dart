import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pro/BottomNavigator/Medicines/medic_&_catg_info.dart';
import 'package:pro/BottomNavigator/Suppliers/supplier_profile.dart';
import 'package:pro/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SupplierProfileAdapter());
  Hive.registerAdapter(CategoryInfoAdapter());
  await Hive.openBox<SupplierProfile>('suppliers');
  await Hive.openBox<CategoryInfo>('categorys');
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





//http://localhost:8000/api/medicines
// {
//     "status": true,
//     "status_code": 200,
//     "medicine": {
//         "medicine_name": "dddd",
//         "arabic_name": "sdsdsdsd",
//         "bar_code": "1212228",
//         "type": "unit",
//         "category_id": "1",
//         "quantity": "1",
//         "alert_quantity": "4",
//         "people_price": "22",
//         "supplier_price": "44",
//         "tax_rate": "3",
//         "updated_at": "2025-06-04T14:37:32.000000Z",
//         "created_at": "2025-06-04T14:37:32.000000Z",
//         "id": 1,
//         "attachments": []
//     },
//     "message": "تم إضافة الدواء والمرفق بنجاح"
// }

//http://localhost:8000/api/generaite-barcode

// {
//     "bar_code": 55094183,
//     "status": true,
//     "status_code": 200
// }