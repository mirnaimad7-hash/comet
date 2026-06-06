import 'package:comet/data/auth_repository.dart';
import 'package:comet/features/login/loginController.dart';
import 'package:comet/features/login/sinUpController.dart';
import 'package:comet/features/login/singUp_screen.dart';
import 'package:comet/home/home.dart';
import 'package:get/get.dart';
import 'package:comet/features/onboarding_screen/splash_screen.dart';
import 'package:comet/features/onboarding_screen/parent_screen.dart';
import 'package:comet/features/login/ui/login_screen.dart';

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
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LoginController(Get.find<AuthRepository>()));
      }),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => const SignUpScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SignUpController(Get.find<AuthRepository>()));
      }),
    ),

    GetPage(name: home, page: () => Home()),
  ];
}
