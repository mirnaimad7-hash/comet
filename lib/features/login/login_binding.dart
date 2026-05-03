// ignore_for_file: unused_import, unused_local_variable

import 'package:comet/core/networking/api_client.dart';
import 'package:get/get.dart';
import 'package:comet/data/auth_repository.dart';
import 'package:comet/core/networking/auth_service.dart';
import 'loginController.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    final authService = AuthService(ApiClient.dio);
    Get.lazyPut(() => AuthRepository(authService));

    Get.lazyPut(() => LoginController(Get.find<AuthRepository>()));
  }
}
