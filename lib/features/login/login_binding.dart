// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:comet/core/networking/auth_service.dart';
import 'loginController.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Dio>(() => Dio());
    Get.lazyPut<AuthService>(() => AuthService(Get.find<Dio>()));

    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<AuthService>()),
    );
  }
}
