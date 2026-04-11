// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;

  void updatePage(int index) {
    currentPage.value = index;
  }

  void goToLogin() {
    Get.toNamed('/login');
  }
}
