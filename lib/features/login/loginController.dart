// ignore_for_file: file_names, deprecated_member_use, depend_on_referenced_packages, unnecessary_null_comparison

import 'package:comet/core/networking/token_service.dart';
import 'package:comet/data/auth_repository.dart';
import 'package:comet/data/auth_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository;
  LoginController(this._authRepository);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
      duration: const Duration(seconds: 4),
    );
  }

  void login() async {
    isLoading.value = true;
    try {
      AuthResponse data = await _authRepository.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      print("--- تم تسجيل الدخول بنجاح والتوكن هو: ${data.accessToken}");

      if (data.accessToken.isNotEmpty) {
        await TokenService().saveTokens(data.accessToken, data.refreshToken);
        Get.offAllNamed('/home');
      }
    } catch (e) {
      String errorMessage = e.toString().replaceAll("Exception: ", "");
      Get.snackbar(
        "فشل تسجيل الدخول",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red[900],
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
