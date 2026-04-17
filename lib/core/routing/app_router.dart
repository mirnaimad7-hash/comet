import 'package:comet/features/login/singUp_screen.dart';
import 'package:get/get.dart';
import 'package:comet/features/onboarding_screen/splash_screen.dart';
import 'package:comet/features/onboarding_screen/parent_screen.dart';
import 'package:comet/features/login/ui/login_screen.dart';
import 'package:comet/features/login/login_binding.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String signUp = '/signUp';
  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => const OnboardingParentScreen()),

    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(name: signUp, page: () => const SignUpScreen()),
    // (تفعليها بعد إنشاء ملفها)
    /* GetPage(
      name: home,
      page: () => const HomeScreen(),
    ), */
  ];
}
