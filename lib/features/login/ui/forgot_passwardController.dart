// ignore_for_file: file_names

import 'package:comet/data/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final AuthRepository _repo = Get.find<AuthRepository>();

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();

  var isLoading = false.obs;
  var currentStep = 0.obs;

  void sendOtp() async {
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar("خطأ", "يرجى إدخال إيميل صحيح");
      return;
    }

    isLoading.value = true;
    try {
      await _repo.forgotPassword(emailController.text.trim());
      currentStep.value = 1;
    } catch (e) {
      Get.snackbar("خطأ", "فشل الاتصال بالسيرفر: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void verifyOtp() async {
    if (otpController.text.length < 4) return;

    isLoading.value = true;
    try {
      await _repo.verifyOtp(
        emailController.text.trim(),
        otpController.text.trim(),
      );
      currentStep.value = 2;
    } catch (e) {
      Get.snackbar("خطأ", "الكود غير صحيح");
    } finally {
      isLoading.value = false;
    }
  }

  void resetPassword() async {
    if (newPasswordController.text.length < 8) {
      Get.snackbar("خطأ", "كلمة المرور يجب أن تكون 8 خانات على الأقل");
      return;
    }

    isLoading.value = true;
    try {
      await _repo.resetPassword(
        emailController.text.trim(),
        newPasswordController.text.trim(),
      );
      Get.offAllNamed('/login');
      Get.snackbar("نجاح", "تم تغيير كلمة المرور بنجاح");
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء تغيير كلمة المرور");
    } finally {
      isLoading.value = false;
    }
  }
}
