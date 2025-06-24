import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pro/Reigster/verify.dart';
import 'package:pro/core/api/dio_consumer.dart';
import 'package:pro/cubit/user_cubit.dart';
import 'package:pro/cubit/user_state.dart';
import 'package:pro/widget/Global.dart';
import 'package:pro/widget/custom_text.dart';

class PersonalInfoForm extends StatefulWidget {
  const PersonalInfoForm({Key? key}) : super(key: key);

  @override
  State<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserCubit(DioConsumer(dio: Dio())),
      child: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserFailure) {
            final errorText = '''
    ${state.message} 
    ${state.details}
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
          if (state is UserSuccess) {
            BotToast.showText(text: "Succes step");
            CustomNavigator.push(
              context,
              BlocProvider.value(
                value: context.read<UserCubit>(),
                child: VerificationCodeScreen(),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<UserCubit>();

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'الاسم',
                      controller: cubit.nameController,
                    ),
                    CustomTextField(
                      label: 'البريد الالكتروني',
                      controller: cubit.emailController,
                    ),
                    CustomTextField(
                      label: 'رقم الهاتف',
                      controller: cubit.phoneController,
                    ),
                    CustomTextField(
                      label: 'كلمة المرور',
                      controller: cubit.passwordController,
                      isPassword: true,
                      passwordVisible: _passwordVisible,
                      onTogglePasswordVisibility:
                          () => setState(
                            () => _passwordVisible = !_passwordVisible,
                          ),
                    ),
                    CustomTextField(
                      label: 'تأكيد كلمة المرور',
                      controller: cubit.confirmPasswordController,
                      isPassword: true,
                      passwordVisible: _confirmPasswordVisible,
                      onTogglePasswordVisibility:
                          () => setState(
                            () =>
                                _confirmPasswordVisible =
                                    !_confirmPasswordVisible,
                          ),
                    ),
                    Row(
                      children: [
                        CustomRadioButton(
                          label: 'ذكر',
                          isSelected: cubit.selectedGender == 'male',
                          onTap: () => cubit.setGender('male'),
                        ),
                        CustomRadioButton(
                          label: 'أنثى',
                          isSelected: cubit.selectedGender == 'female',
                          onTap: () => cubit.setGender('female'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed:
                          state is UserLoading
                              ? null
                              : () => cubit.registerUsers(),

                      child:
                          state is UserLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text('تأكيد'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
