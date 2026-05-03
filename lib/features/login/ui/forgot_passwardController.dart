import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();

  var isLoading = false.obs;
  var currentStep = 0.obs; // 0: إرسال إيميل, 1: كود التحقق, 2: كلمة سر جديدة

  // 1. إرسال طلب رمز التحقق
  void sendOtp() async {
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        "خطأ",
        "يرجى إدخال إيميل صحيح",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // محاكاة API
    isLoading.value = false;
    currentStep.value = 1; // الانتقال لصفحة الكود
  }

  // 2. التحقق من الكود (OTP)
  void verifyOtp() async {
    if (otpController.text.length < 4) return;

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    currentStep.value = 2; // الانتقال لصفحة تغيير كلمة السر
  }

  // 3. تعيين كلمة السر الجديدة
  void resetPassword() async {
    if (newPasswordController.text.length < 8) return;

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    Get.offAllNamed('/login'); // العودة للوجن بعد النجاح
    Get.snackbar(
      "نجاح",
      "تم تغيير كلمة المرور بنجاح",
      snackPosition: SnackPosition.TOP,
    );
  }
}
