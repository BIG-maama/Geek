import 'dart:async';
import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pro/home.dart';
import 'package:pro/widget/token.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  Future<void> verify() async {
    try {
      final token = await tokenManager.getToken();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.105:8000/api/verify-email-code'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['verification_code'] = _codeController.text;
      request.fields['email'] = _emailcontroller.text;

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);
        final showmessage = data['message'] ?? 'تم التحقق بنجاح';

        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'نجاح!',
            message: showmessage,
            contentType: ContentType.success,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print("Success: $showmessage");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => king()),
        );
      } else {
        final data = jsonDecode(responseData);
        final errorMessage = data['message'] ?? 'حدث خطأ غير متوقع';

        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'خطأ!',
            message: errorMessage,
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print("Error ${response.statusCode}: $errorMessage");
      }
    } catch (e) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'استثناء!',
          message: 'حدث خطأ أثناء التحقق: $e',
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print("Exception: $e");
    }
  }

  bool isButtonEnabled = false;

  void _validateInputs() {
    final isCodeNotEmpty = _codeController.text.trim().isNotEmpty;
    final isEmailNotEmpty = _emailcontroller.text.trim().isNotEmpty;

    setState(() {
      isButtonEnabled = isCodeNotEmpty && isEmailNotEmpty;
    });
  }

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  int _remainingSeconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _codeController.addListener(_validateInputs);
    _emailcontroller.addListener(_validateInputs);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.removeListener(_validateInputs);
    _emailcontroller.removeListener(_validateInputs);
    _codeController.dispose();
    _emailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
                vertical: screenHeight * 0.05,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back arrow
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CustomPaint(
                          size: const Size(13, 27),
                          painter: BackArrowPainter(),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),
                  const SizedBox(height: 12),

                  const Text(
                    'ادخل الرمز الذي وصلك على الايميل المسجل مع ادخال الايميل المسجل ',
                    style: TextStyle(
                      color: Color(0xFFC7C7C7),
                      fontFamily: 'Almarai',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenHeight * 0.06),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'رمز التحقق',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Almarai',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        width: screenWidth * 0.85,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: TextFormField(
                            cursorColor: Colors.teal,
                            controller: _codeController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(
                              color: Colors.teal,
                              fontFamily: 'Almarai',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'XXXXX',
                              hintStyle: TextStyle(
                                color: Color(0xFFC2C2C2),
                                fontFamily: 'Almarai',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Text(
                        'البريد الالكتروني المسجل',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Almarai',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        width: screenWidth * 0.85,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: TextFormField(
                            cursorColor: Colors.teal,
                            controller: _emailcontroller,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              color: Colors.teal,
                              fontFamily: 'Almarai',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'البريد الالكتروني',
                              hintStyle: TextStyle(
                                color: Color(0xFFC2C2C2),
                                fontFamily: 'Almarai',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      GestureDetector(
                        onTap:
                            isButtonEnabled
                                ? () {
                                  verify();
                                  print("تم التأكيد");
                                }
                                : null,
                        child: Container(
                          width: screenWidth * 0.85,
                          height: 48,
                          decoration: BoxDecoration(
                            color:
                                isButtonEnabled
                                    ? const Color(0xFF06DE87)
                                    : Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'تأكيد العملية',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Almarai',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'اعادة ارسال الرمز بعد (${_remainingSeconds}ثانية)',
                    style: const TextStyle(
                      color: Color(0xFFC2C2C2),
                      fontFamily: 'Almarai',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
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

class BackArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(1, 1);
    path.lineTo(14, 14.5);
    path.lineTo(1, 28);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
