import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pro/Reigster/Rigster.dart';
import 'package:pro/widget/token.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  @override
  State<WelcomeScreen> createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {
  String? _token;
  String? _errorMessage;

  // Future<void> _signInWithGoogle() async {
  //   final url = "http://192.168.1.9:8000/api/auth/google";
  //   try {
  //     if (await canLaunch(url)) {
  //       await launch(url); // فتح واجهة Google OAuth
  //       // بعد اختيار الحساب، توقع الرد من API الثانية
  //       final callbackUrl = "http://192.168.1.9:8000/api/auth/google/callback";
  //       final response = await http.get(Uri.parse(callbackUrl));
  //       if (response.statusCode == 200) {
  //         final data = json.decode(response.body);

  //         setState(() {
  //           _token = data['token'];
  //           _errorMessage = null;
  //         });
  //         await tokenManager.saveToken(_token!);
  //         print("sucsses");
  //       } else {
  //         print(_errorMessage = "Error: ${response.body}");
  //       }
  //     } else {
  //       print(_errorMessage = "Cannot launch URL. Check your configuration.");
  //     }
  //   } catch (e) {
  //     print(_errorMessage = "Error: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
                vertical: screenHeight * 0.04,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/splash_screen-Photoroom.png",
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.4,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 80),

                  const Text(
                    'مرحبا بك في تطبيق دواء.',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF06DE87),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PersonalInfoForm()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // نص الزر
                          const Text(
                            ' أنشاء حساب من خلال الايميل ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          // أيقونة Google
                          Image.asset(
                            "images/email.png",
                            width: 45,
                            height: 45,
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF06DE87),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        // await _signInWithGoogle();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // نص الزر
                          const Text(
                            'التسجيل من خلال حساب غوغل ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          // أيقونة Google
                          Image.asset(
                            "images/google.png",
                            width: 28,
                            height: 28,
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // نص الشروط
                  const Text(
                    'من خلال انشاء حساب في التطبيق فقد قمت بالموافقة على الشروط والاحكام',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8F8F8F),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}








 // static const String _googleLoginUrl =
  //     "http://192.168.1.9:8000/api/auth/google";
  // static const String _callbackUrlScheme = "com.example.pro";

  // static Future<void> signInWithGoogle(BuildContext context) async {
  //   try {
  //     // 1. فتح صفحة تسجيل الدخول
  //     final result = await FlutterWebAuth2.authenticate(
  //       url: _googleLoginUrl,
  //       callbackUrlScheme: _callbackUrlScheme,
  //     );

  //     // 2. استخراج الـ token من الرابط العائد
  //     final token = Uri.parse(result).queryParameters['token'];

  //     if (token != null) {
  //       // 3. حفظ التوكن
  //       await tokenManager.saveToken(token);
  //       print("تم حفظ التوكن: $token");

  //       // 4. الانتقال إلى الصفحة الرئيسية
  //       Navigator.pushReplacementNamed(context, '/home');
  //     } else {
  //       throw Exception('لم يتم العثور على التوكن في الرابط العائد');
  //     }
  //   } catch (e) {
  //     print('خطأ أثناء تسجيل الدخول عبر جوجل: $e');
  //   }
  // }