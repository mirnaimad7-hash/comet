
// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'hello': 'Hello',
      'get_started': 'Get Started',
      'login_msg': 'ALREADY HAVE AN ACCOUNT? LOG IN',
    },
    'ar': {
      'hello': 'أهلاً بك',
      'get_started': 'ابدأ الآن',
      'login_msg': 'لديك حساب بالفعل؟ تسجيل الدخول',
    }
  };
}