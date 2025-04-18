import 'package:flutter/material.dart';
import 'package:pro/onborading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 3));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Almarai'),
      home: const SkipScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
