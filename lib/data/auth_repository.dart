// ignore_for_file: unused_import

import 'package:comet/core/api/api_consumer.dart';
import 'package:comet/core/errors/error_handler.dart';
import 'package:comet/core/networking/api_endpoints.dart';
import 'package:comet/data/auth_response_model.dart';
import 'package:comet/features/login/ui/forgot_passwardController.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final ApiConsumer apiConsumer;

  AuthRepository(this.apiConsumer);

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await apiConsumer.post(
        ApiEndpoints.signin,
        data: {'email': email, 'password': password},
      );
      return AuthResponse.fromJson(response);
    } on DioException catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }

  Future<AuthResponse> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await apiConsumer.post(
        ApiEndpoints.signup,
        data: {"name": name, "email": email, "password": password},
      );
      return AuthResponse.fromJson(response);
    } on DioException catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }

  Future<dynamic> forgotPassword(String email) async {
    try {
      return await apiConsumer.post(
        ApiEndpoints.forgotPassword,
        data: {"email": email},
      );
    } on DioException catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }

  Future<dynamic> verifyOtp(String email, String otp) async {
    try {
      return await apiConsumer.post(
        ApiEndpoints.verifyOtp,
        data: {"email": email, "otp": otp},
      );
    } on DioException catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }

  Future<dynamic> resetPassword(String email, String password) async {
    try {
      return await apiConsumer.post(
        ApiEndpoints.resetPassword,
        data: {"email": email, "newPassword": password},
      );
    } on DioException catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }
}
