import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pro/home.dart';
import 'package:pro/widget/Global.dart';
import 'package:pro/widget/custom_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<void> sign_in() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/login-user'),
    );
    request.fields['email'] = _emailController.text.trim();
    request.fields['password'] = _passwordController.text.trim();

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('تمت العملية بنجاح'),
      //     duration: Duration(seconds: 2),
      //     backgroundColor: Colors.green,
      //     behavior: SnackBarBehavior.floating,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //   ),
      // );

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'نجاح!',
          message: 'تم تنفيذ العملية بنجاح تام 🎉',
          contentType: ContentType.success,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      print("sucssess pro");
      Navigator.push(context, MaterialPageRoute(builder: (_) => king()));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl, // RTL for Arabic
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 51.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 67.0),

                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Image.asset(
                      "images/back.png", // Replace with actual asset path
                      width: 15.0,
                      height: 15.0 / 0.52, // Based on aspect ratio from design
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  const Text(
                    'مرحبا بك في تطبيق دواء.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),

                  const SizedBox(height: 12.0),

                  Text(
                    'التسجيل من خلال الايميل',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 15.0,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),

                  const SizedBox(height: 54.0),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 5.0,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          size: 21.0,
                          color: AppColors.hintText,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextFormField(
                            cursorColor: Colors.teal,
                            style: TextStyle(
                              color: Colors.teal,
                              fontFamily: 'Almarai',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: 'البريد الالكتروني',
                              hintStyle: TextStyle(
                                color: AppColors.hintText,
                                fontSize: 16.0,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.bold,
                              ),
                              border: InputBorder.none,

                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18.0),

                  Container(
                    width: 291.0,
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 5.0,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lock, size: 21.0, color: AppColors.hintText),

                        Expanded(
                          child: TextFormField(
                            cursorColor: Colors.teal,
                            controller: _passwordController,
                            style: TextStyle(
                              color: Colors.teal,
                              fontFamily: 'Almarai',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              hintText: '  كلمة السر ',
                              hintStyle: TextStyle(
                                color: AppColors.hintText,
                                fontSize: 16.0,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.bold,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18.0),

                  Center(
                    child: SizedBox(
                      width: 291.0,
                      child: ElevatedButton(
                        onPressed: () {
                          sign_in();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 442.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
