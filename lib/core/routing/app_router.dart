// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:comet/features/onboarding_screen/splash_screen.dart';
import 'package:comet/features/onboarding_screen/parent_screen.dart';
import 'package:comet/features/login/ui/login_screen.dart';
import 'package:comet/features/login/login_binding.dart';
// import 'package:comet/features/home/ui/home_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),

    GetPage(name: onboarding, page: () => const OnboardingParentScreen()),

    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    // 4. صفحة الهوم
    /* GetPage(
      name: home,
      page: () => const HomeScreen(),
    ), */
  ];
}
