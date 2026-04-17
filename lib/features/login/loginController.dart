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

  var emailError = "".obs;
  var passwordError = "".obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool _isValid() {
    emailError.value = "";
    passwordError.value = "";
    bool valid = true;

    if (emailController.text.trim().isEmpty) {
      emailError.value = "يرجى إدخال البريد الإلكتروني";
      valid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = "صيغة البريد الإلكتروني غير صحيحة";
      valid = false;
    }

    if (passwordController.text.isEmpty) {
      passwordError.value = "يرجى إدخال كلمة المرور";
      valid = false;
    }

    if (!valid) {
      _showErrorSnackbar("تنبيه", "يرجى التأكد من الحقول الحمراء");
    }

    return valid;
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent.withOpacity(0.1),
      colorText: Colors.red[900],
      margin: const EdgeInsets.all(15),
      borderRadius: 15,
      duration: const Duration(seconds: 3),
    );
  }

  void login() async {
    if (!_isValid()) return;

    try {
      isLoading.value = true;
      final response = await _authService.login({
        "email": emailController.text.trim(),
        "password": passwordController.text,
      });

      String? token = response.accessToken;

      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        Get.offAllNamed('/home');
      }
    } catch (e) {
      _showErrorSnackbar("فشل الدخول", "تأكد من البيانات أو الاتصال بالإنترنت");
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
