import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pro/BottomNavigator/Medicines/medic_&_catg_info.dart';
import 'package:pro/BottomNavigator/Suppliers/supplier_profile.dart';
import 'package:pro/BottomNavigator/Suppliers/supplier_purchase.dart';
import 'package:pro/BottomNavigator/inventory/hive_inventory.dart';
import 'package:pro/batches/hive_save.dart';
import 'package:pro/invoices/all_invocies.dart';
import 'package:pro/invoices/invocies_pro.dart';
import 'package:pro/widget/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CategoryInfoAdapter());
  Hive.registerAdapter(PricesAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(MedicineModelAdapter());
  Hive.registerAdapter(BatchModelAdapter());
  Hive.registerAdapter(MedicineFormAdapter());
  Hive.registerAdapter(AttachmentAdapter());
  Hive.registerAdapter(StatusAdapter());
  Hive.registerAdapter(MedicInfoAdapter());
  Hive.registerAdapter(InventoryCountAdapter());
  Hive.registerAdapter(InventoryItemAdapter());
  Hive.registerAdapter(MedicineAdapter());
  Hive.registerAdapter(MetaAdapter());
  Hive.registerAdapter(SupplierAdapter());
  Hive.registerAdapter(InvoiceAdapter());
  Hive.registerAdapter(MedicineItemAdapter());
  await Hive.openBox<Invoice>('invoices');
  await Hive.openBox<Supplier>('suppliers');
  await Hive.openBox<CategoryInfo>('categorys');
  await Hive.openBox<MedicInfo>('medics');
  await Hive.openBox<BatchModel>('batches');
  await Hive.openBox<Meta>('meta');
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
      home: SplashScreen(),
      // home: BlocProvider(
      //   create: (_) => UserCubit(DioConsumer(dio: Dio())),
      //   child: King(),
      // ),
      debugShowCheckedModeBanner: false,
    );
  }
}






























// http://localhost:8000/api/brands
// {
//     "status": true,
//     "message": "Brand created successfully",
//     "data": {
//         "name": "soso Brand",
//         "company_name": "Al-Damas",
//         "description": "Empty",
//         "updated_at": "2025-06-16T15:22:50.000000Z",
//         "created_at": "2025-06-16T15:22:50.000000Z",
//         "id": 3
//     }
// }

//********************************************************************************************************************** */


//http://localhost:8000/api/brands
// {
//     "status": true,
//     "data": [
//         {
//             "id": 1,
//             "name": "paracetamol Brand",
//             "description": "Empty",
//             "company_name": "AL_HAKEM",
//             "created_at": "2025-06-16T15:22:12.000000Z",
//             "updated_at": "2025-06-16T15:22:12.000000Z"
//         },
//         {
//             "id": 2,
//             "name": "farma Brand",
//             "description": "Empty",
//             "company_name": "Al_Raqa",
//             "created_at": "2025-06-16T15:22:30.000000Z",
//             "updated_at": "2025-06-16T15:22:30.000000Z"
//         },
//         {
//             "id": 3,
//             "name": "soso Brand",
//             "description": "Empty",
//             "company_name": "Al-Damas",
//             "created_at": "2025-06-16T15:22:50.000000Z",
//             "updated_at": "2025-06-16T15:22:50.000000Z"
//         }
//     ]
// }

//*********************************************************************************************************** */


//http://localhost:8000/api/brands/1
// {
//     "status": true,
//     "data": {
//         "id": 1,
//         "name": "paracetamol Brand",
//         "description": "Empty",
//         "company_name": "AL_HAKEM",
//         "created_at": "2025-06-16T15:22:12.000000Z",
//         "updated_at": "2025-06-16T15:22:12.000000Z"
//     }
// }

//**************************************************************************************************************** */
//http://localhost:8000/api/brands/1
// {
//     "status": true,
//     "message": "Brand deleted successfully"
// }