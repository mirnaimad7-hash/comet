// ignore_for_file: unused_field, unused_import

import 'package:comet/core/errors/error_handler.dart';
import 'package:comet/core/networking/auth_service.dart';
import 'package:comet/data/auth_response_model.dart';
import 'package:dio/dio.dart';
import '../../core/networking/api_client.dart';
import '../../core/networking/api_endpoints.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);
  Future<AuthResponse> login(String email, String password) async {
    try {
      return await _authService.login({"email": email, "password": password});
    } on DioException catch (e) {
      print("❌ ------------------- الخطأ الكامل -------------------");
      print("Error: $e"); // هنا سنرى السبب الحقيقي (Type, Path, etc)
      print("❌ ---------------------------------------------------");

      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }

  Future<AuthResponse> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      return await _authService.signUp({
        "name": name,
        "email": email,
        "password": password,
      });
    } on DioException catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }
}
