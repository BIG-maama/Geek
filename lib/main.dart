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
  Hive.registerAdapter(PricesAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(MedicineFormAdapter());
  Hive.registerAdapter(StatusAdapter());
  Hive.registerAdapter(MedicInfoAdapter());
  await Hive.openBox<SupplierProfile>('suppliers');
  await Hive.openBox<CategoryInfo>('categorys');
  await Hive.deleteBoxFromDisk('medics');
  await Hive.openBox<MedicInfo>('medics');
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






//http://localhost:8000/api/show-all-alternatives/1

//  {
//     "status": true,
//     "status_code": 200,
//     "message": "تم جلب الأدوية البديلة بنجاح",
//     "data": {
//         "medicine": {
//             "id": 1,
//             "name": "ddddddq",
//             "scientific_name": null,
//             "arabic_name": "sdsdsdsl",
//             "barcode": "12121213"
//         },
//         "alternatives": [
//             {
//                 "id": 2,
//                 "name": "dddd",
//                 "scientific_name": null,
//                 "arabic_name": "sdsds",
//                 "barcode": "12121215",
//                 "type": "unit",
//                 "quantity": 12,
//                 "prices": {
//                     "people_price": "22.00",
//                     "supplier_price": "44.00"
//                 },
//                 "category": {
//                     "id": 1,
//                     "name": "مسكنات"
//                 }
//             },
//             {
//                 "id": 3,
//                 "name": "ddddtt",
//                 "scientific_name": null,
//                 "arabic_name": "sdsdsyy",
//                 "barcode": "12121255",
//                 "type": "unit",
//                 "quantity": 12,
//                 "prices": {
//                     "people_price": "22.00",
//                     "supplier_price": "44.00"
//                 },
//                 "category": {
//                     "id": 1,
//                     "name": "مسكنات"
//                 }
//             }
//         ]
//     },
//     "meta": {
//         "total_alternatives": 2
//     }
// }

