import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pro/cubit/user_cubit.dart';
import 'package:pro/cubit/user_state.dart';
import 'package:pro/home.dart';
import 'package:pro/widget/Global.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool isButtonEnabled = false;
  int _remainingSeconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _codeController.addListener(_validateInputs);
    _emailController.addListener(_validateInputs);
  }

  void _validateInputs() {
    final isCodeNotEmpty = _codeController.text.trim().isNotEmpty;
    final isEmailNotEmpty = _emailController.text.trim().isNotEmpty;

    setState(() {
      isButtonEnabled = isCodeNotEmpty && isEmailNotEmpty;
    });
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
    _emailController.removeListener(_validateInputs);
    _codeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('تم التحقق بنجاح')));

          Future.microtask(() {
            CustomNavigator.pushReplacement(
              context,
              BlocProvider.value(
                value: context.read<UserCubit>(),
                child: const King(),
              ),
            );
          });
        } else if (state is UserFailure) {
          final errorText = '''
${state.message}
''';
          Fluttertoast.showToast(
            msg: errorText,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<UserCubit>();

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
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CustomPaint(size: const Size(13, 27)),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
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

                      // رمز التحقق
                      const Text(
                        'رمز التحقق',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildInputField(_codeController, 'XXXXX'),

                      const SizedBox(height: 16),
                      const Text(
                        'البريد الالكتروني المسجل',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildInputField(_emailController, 'البريد الالكتروني'),

                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap:
                            isButtonEnabled && state is! UserLoading
                                ? () {
                                  cubit.registerVerify(
                                    email: _emailController.text.trim(),
                                    code: _codeController.text.trim(),
                                  );
                                }
                                : null,
                        child: Container(
                          width: screenWidth * 0.85,
                          height: 48,
                          decoration: BoxDecoration(
                            color:
                                isButtonEnabled && state is! UserLoading
                                    ? const Color(0xFF06DE87)
                                    : Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child:
                                state is UserLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : const Text(
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
      },
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.teal,
            fontFamily: 'Almarai',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFFC2C2C2),
              fontFamily: 'Almarai',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
