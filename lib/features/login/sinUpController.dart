// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isPasswordObscured = true.obs;
  var isConfirmPasswordObscured = true.obs;
  var isLoading = false.obs;
  var nameError = "".obs;
  var emailError = "".obs;
  var passwordError = "".obs;
  var confirmError = "".obs;

  void togglePasswordVisibility() => isPasswordObscured.toggle();
  void toggleConfirmVisibility() => isConfirmPasswordObscured.toggle();

  bool _isValid() {
    nameError.value = "";
    emailError.value = "";
    passwordError.value = "";
    confirmError.value = "";

    bool valid = true;

    if (nameController.text.trim().isEmpty) {
      nameError.value = "يرجى إدخال الاسم الكامل";
      valid = false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = "صيغة البريد الإلكتروني غير صحيحة";
      valid = false;
    }

    if (passwordController.text.length < 8) {
      passwordError.value = "يجب أن تكون كلمة المرور 8 محارف على الأقل";
      valid = false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      confirmError.value = "كلمات المرور غير متطابقة";
      valid = false;
    }

    return valid;
  }

  void signUp() async {
    if (!_isValid()) return;

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        "نجاح",
        "تم إنشاء الحساب بنجاح",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green[800],
      );

      // Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء التسجيل",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
