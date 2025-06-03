// import 'dart:convert';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pro/Reigster/verify.dart';
// import 'package:pro/widget/Global.dart';
// import 'package:pro/widget/custom_text.dart';
// import 'package:pro/widget/profile.dart';
// import 'package:pro/widget/token.dart';

// class PersonalInfoForm extends StatefulWidget {
//   const PersonalInfoForm({Key? key}) : super(key: key);

//   @override
//   State<PersonalInfoForm> createState() => _PersonalInfoFormState();
// }

// class _PersonalInfoFormState extends State<PersonalInfoForm> {
//   UserModel? currentUser;

//   @override
//   void initState() {
//     super.initState();
//     _resetControllers();
//   }

//   void _resetControllers() {
//     _phoneController.clear();
//     _nameController.clear();
//     _emailController.clear();
//     _passwordController.clear();
//     _confirmPasswordController.clear();
//     gendercontroller.clear();
//   }

//   Future<void> registerUser() async {
//     gendercontroller.text = _selectedGender;
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('$baseUrl/api/register-user'),
//     );

//     request.fields['name'] = _nameController.text;
//     request.fields['email'] = _emailController.text;
//     request.fields['phone'] = _phoneController.text;
//     request.fields['password'] = _passwordController.text;
//     request.fields['password_confirmation'] = _confirmPasswordController.text;
//     request.fields['gender'] = gendercontroller.text;

//     var response = await request.send();

//     if (response.statusCode == 201) {
//       var responseData = await response.stream.bytesToString();
//       final data = jsonDecode(responseData);
//       final token = data['token'];
//       UserData.currentUser = UserModel.fromJson(data['user']);

//       await tokenManager.saveToken(token);
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'نجاح!',
//           message: 'تم تنفيذ العملية بنجاح تام 🎉',
//           contentType: ContentType.success,
//         ),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => VerificationCodeScreen()),
//       );
//     }
//   }

//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController gendercontroller = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   bool _passwordVisible = false;
//   bool _confirmPasswordVisible = false;
//   String _selectedGender = 'male';

//   void _togglePasswordVisibility() {
//     setState(() {
//       _passwordVisible = !_passwordVisible;
//     });
//   }

//   void _toggleConfirmPasswordVisibility() {
//     setState(() {
//       _confirmPasswordVisible = !_confirmPasswordVisible;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Directionality(
//           textDirection: TextDirection.rtl, // Set RTL for Arabic
//           child: SingleChildScrollView(
//             child: Container(
//               width: double.infinity,
//               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 20),
//                   // Back arrow
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding: EdgeInsets.only(right: screenWidth * 0.07),
//                       child: GestureDetector(
//                         onTap: () => Navigator.of(context).pop(),
//                         child: SizedBox(
//                           width: 13,
//                           height: 27,
//                           child: CustomPaint(painter: BackArrowPainter()),
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 40),

//                   // Title
//                   const Text(
//                     'اكمل البيانات الشخصية',
//                     style: TextStyle(
//                       fontFamily: 'Almarai',
//                       fontSize: 24,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black,
//                     ),
//                   ),

//                   const SizedBox(height: 12),

//                   // Subtitle
//                   const Text(
//                     'من فضلك قم باستكمال البيانات الشخصية',
//                     style: TextStyle(
//                       fontFamily: 'Almarai',
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFFC7C7C7),
//                     ),
//                   ),

//                   const SizedBox(height: 30),

//                   // Form fields
//                   Container(
//                     constraints: BoxConstraints(maxWidth: 500),
//                     child: Column(
//                       children: [
//                         // Phone number field
//                         CustomTextField(
//                           label: 'الرقم:',
//                           controller: _phoneController,
//                           prefixText: '+963',
//                           keyboardType: TextInputType.phone,
//                         ),

//                         const SizedBox(height: 20),

//                         // Name field
//                         CustomTextField(
//                           label: 'الاسم:',
//                           placeholder: 'ادخل اسمك',
//                           controller: _nameController,
//                         ),

//                         const SizedBox(height: 20),

//                         // Email field
//                         CustomTextField(
//                           label: 'البريد الالكتروني:',
//                           placeholder: 'ادخل البريد الالكتروني',
//                           controller: _emailController,
//                           keyboardType: TextInputType.emailAddress,
//                         ),

//                         const SizedBox(height: 20),

//                         // Password field
//                         CustomTextField(
//                           label: 'كلمة المرور:',
//                           placeholder: 'ادخل كلمة المرور',
//                           isPassword: true,
//                           controller: _passwordController,
//                           passwordVisible: _passwordVisible,
//                           onTogglePasswordVisibility: _togglePasswordVisibility,
//                         ),

//                         const SizedBox(height: 20),

//                         // Confirm password field
//                         CustomTextField(
//                           label: 'اعادة تعيين كلمة المرور:',
//                           placeholder: 'اعادة تعيين كلمة المرور',
//                           isPassword: true,
//                           controller: _confirmPasswordController,
//                           passwordVisible: _confirmPasswordVisible,
//                           onTogglePasswordVisibility:
//                               _toggleConfirmPasswordVisibility,
//                         ),

//                         const SizedBox(height: 20),

//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'النوع:',
//                               style: TextStyle(
//                                 fontFamily: 'Almarai',
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             const SizedBox(height: 5),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 CustomRadioButton(
//                                   label: 'ذكر',
//                                   isSelected: _selectedGender == 'male',
//                                   onTap: () {
//                                     setState(() {
//                                       _selectedGender = 'male';
//                                     });
//                                   },
//                                 ),
//                                 CustomRadioButton(
//                                   label: 'انثى',
//                                   isSelected: _selectedGender == 'female',
//                                   onTap: () {
//                                     setState(() {
//                                       _selectedGender = 'female';
//                                     });
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 40),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF06DE87),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       onPressed: () {
//                         registerUser();
//                       },
//                       child: const Text(
//                         'تاكيد',
//                         style: TextStyle(
//                           fontFamily: 'Almarai',
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class BackArrowPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint =
//         Paint()
//           ..color = Colors.black
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 2
//           ..strokeCap = StrokeCap.round
//           ..strokeJoin = StrokeJoin.round;

//     final Path path = Path();
//     path.moveTo(size.width, 1);
//     path.lineTo(1, size.height / 2);
//     path.lineTo(size.width, size.height);

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
//////////////////////////////////////////////////////////////////////////////////////////////////////////
import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pro/Reigster/verify.dart';
import 'package:pro/widget/Global.dart';
import 'package:pro/widget/custom_text.dart';
import 'package:pro/widget/profile.dart';
import 'package:pro/widget/token.dart';

// MODEL
class RegisterFormState {
  final bool isLoading;
  final String selectedGender;

  RegisterFormState({this.isLoading = false, this.selectedGender = 'male'});

  RegisterFormState copyWith({bool? isLoading, String? selectedGender}) {
    return RegisterFormState(
      isLoading: isLoading ?? this.isLoading,
      selectedGender: selectedGender ?? this.selectedGender,
    );
  }
}

// STATE NOTIFIER
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  RegisterFormNotifier() : super(RegisterFormState());

  void setGender(String gender) {
    state = state.copyWith(selectedGender: gender);
  }

  Future<void> registerUser({
    required BuildContext context,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final gender = state.selectedGender;
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/register-user'),
      );

      request.fields['name'] = nameController.text;
      request.fields['email'] = emailController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['password'] = passwordController.text;
      request.fields['password_confirmation'] = confirmPasswordController.text;
      request.fields['gender'] = gender;

      var response = await request.send();

      if (response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        final token = data['token'];
        UserData.currentUser = UserModel.fromJson(data['user']);

        await tokenManager.saveToken(token);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'نجاح!',
              message: 'تم تنفيذ العملية بنجاح تام 🎉',
              contentType: ContentType.success,
            ),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VerificationCodeScreen()),
        );
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle exception
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final registerFormProvider =
    StateNotifierProvider<RegisterFormNotifier, RegisterFormState>((ref) {
      return RegisterFormNotifier();
    });

// UI WIDGET
class PersonalInfoForm extends ConsumerStatefulWidget {
  const PersonalInfoForm({Key? key}) : super(key: key);

  @override
  ConsumerState<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends ConsumerState<PersonalInfoForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(registerFormProvider);
    final formNotifier = ref.read(registerFormProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextField(label: 'الاسم', controller: _nameController),
              CustomTextField(
                label: 'البريد الالكتروني',
                controller: _emailController,
              ),
              CustomTextField(
                label: 'رقم الهاتف',
                controller: _phoneController,
              ),
              CustomTextField(
                label: 'كلمة المرور',
                controller: _passwordController,
                isPassword: true,
                passwordVisible: _passwordVisible,
                onTogglePasswordVisibility:
                    () => setState(() => _passwordVisible = !_passwordVisible),
              ),
              CustomTextField(
                label: 'تأكيد كلمة المرور',
                controller: _confirmPasswordController,
                isPassword: true,
                passwordVisible: _confirmPasswordVisible,
                onTogglePasswordVisibility:
                    () => setState(
                      () => _confirmPasswordVisible = !_confirmPasswordVisible,
                    ),
              ),
              Row(
                children: [
                  CustomRadioButton(
                    label: 'ذكر',
                    isSelected: formState.selectedGender == 'male',
                    onTap: () => formNotifier.setGender('male'),
                  ),
                  CustomRadioButton(
                    label: 'أنثى',
                    isSelected: formState.selectedGender == 'female',
                    onTap: () => formNotifier.setGender('female'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    formState.isLoading
                        ? null
                        : () => formNotifier.registerUser(
                          context: context,
                          nameController: _nameController,
                          emailController: _emailController,
                          phoneController: _phoneController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                        ),
                child:
                    formState.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : const Text('تأكيد'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
