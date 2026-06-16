// ignore_for_file: file_names, deprecated_member_use, unnecessary_null_comparison
import 'package:comet/core/networking/token_service.dart';
import 'package:comet/data/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:comet/core/exceptions/app_exceptions.dart'; // سننشئ هذا الملف لاحقاً

class SignUpController extends GetxController {
  final AuthRepository _authRepository;

  SignUpController(this._authRepository);

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
    print("-------------جاري الارسال ");
    if (!_isValid()) return;

    try {
      isLoading.value = true;
      final response = await _authRepository.signUp(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print("السيرفر رد, التوكن هو :${response.accessToken}");
      if (response.accessToken != null) {
        await TokenService().saveTokens(
          response.accessToken,
          response.refreshToken,
        );
        print("تم حفظ التوكن ");
      }

      Get.snackbar(
        "نجاح",
        "تم إنشاء الحساب بنجاح",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green[800],
      );

      Get.offAllNamed('/home');
    } catch (e) {
      String errorMessage = "حدث خطأ أثناء التسجيل";

      if (e is AppExceptions) {
        errorMessage = e.message;
      }

      Get.snackbar(
        "خطأ",
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
