// ignore_for_file: unused_field, file_names, deprecated_member_use, depend_on_referenced_packages

import 'package:comet/core/networking/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService _authService;
  LoginController(this._authService);

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "خطأ",
        "يرجى ملء جميع الحقول",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await _authService.login({
        "email": emailController.text,
        "password": passwordController.text,
      });

      // 3. استخراج التوكن
      String? token = response.accessToken;

      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        print("Token saved successfully via SharedPreferences");

        Get.offAllNamed('/home');
      }
    } catch (e) {
      print("Login Error: $e");
      Get.snackbar(
        "فشل تسجيل الدخول",
        "تأكد من البيانات أو الاتصال بالإنترنت",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.7),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
