import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pro/BottomNavigator/Medicines/medic_&_catg_info.dart';
import 'package:pro/BottomNavigator/Suppliers/supplier_profile.dart';
import 'package:pro/widget/splash_screen.dart';

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
  //await Hive.deleteBoxFromDisk('medics');
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