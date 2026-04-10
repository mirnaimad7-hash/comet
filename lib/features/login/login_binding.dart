// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:comet/core/networking/auth_service.dart';
import 'loginController.dart'; // تأكدي أن المسار صحيح

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // تجهيز Dio
    Get.lazyPut<Dio>(() => Dio());

    // تجهيز الـ Service (الذي يحتاجه الكنترولر)
    Get.lazyPut<AuthService>(() => AuthService(Get.find<Dio>()));

    // تجهيز الـ Controller (الذي تحتاجه الصفحة)
    // الآن بما أننا مررنا Get.find<AuthService>()، سيتوقف الخطأ في الكنترولر
    Get.lazyPut<LoginController>(() => LoginController(Get.find<AuthService>()));
  }
}