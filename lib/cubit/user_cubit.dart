import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pro/core/api/api_consumer.dart';
import 'package:pro/core/api/end_point.dart';
import 'package:pro/core/error/exception.dart';
import 'package:pro/widget/Global.dart';
import 'package:pro/widget/token.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.api) : super(UserInitial());

  String selectedGender = 'male';
  final ApiConsumer api;
  GlobalKey<FormState> registerFormKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void setGender(String gender) {
    selectedGender = gender;
    emit(UserGenderUpdated(gender));
  }

  registerUsers() async {
    try {
      emit(UserLoading());

      final response = await api.post(
        '$baseUrl/api/register-user',
        data: {
          ApiKey.name: nameController.text,
          ApiKey.email: emailController.text,
          ApiKey.phone: phoneController.text,
          ApiKey.password: passwordController.text,
          ApiKey.password_confirmation: confirmPasswordController.text,
          ApiKey.gender: selectedGender,
        },
      );

      final token = response['token'];

      if (token != null) {
        await tokenManager.saveToken(token);
      }

      emit(UserSuccess());
    } on ServerException catch (e) {
      emit(UserFailure(e.errModel.message, e.errModel.details));
    }
  }

  registerVerify({required String email, required String code}) async {
    try {
      emit(UserLoading());
      final response = await api.post(
        '$baseUrl/api/verify-email-code',
        data: {ApiKey.email: email, ApiKey.verification_code: code},
      );

      emit(UserSuccess());
    } on ServerException catch (e) {
      emit(UserFailure(e.errModel.message, e.errModel.details));
    }
  }

  signOut() async {
    try {
      emit(UserLoading());
      final response = await api.post("$baseUrl/api/logout-user");
      print(response);
      if (response["status"] == "success") {
        await tokenManager.clearToken();
        emit(UserSuccess());
      }
    } on ServerException catch (e) {
      emit(UserFailure(e.errModel.message, e.errModel.details));
    }
  }

  login(String email, String password) async {
    try {
      emit(UserLoading());
      final response = await api.post(
        "$baseUrl/api/login-user",
        data: {"email": email, "password": password},
      );
      print("gg");
      print(response.toString());
      final token = response['token'];

      if (token != null) {
        await tokenManager.saveToken(token);
      }
      emit(UserSuccess());
    } on ServerException catch (e) {
      emit(UserFailure(e.errModel.message, e.errModel.details));
    }
  }
}
