import 'package:get/get.dart';
// استيراد الواجهات (تأكدي من صحة المسارات لديكِ)
import 'package:comet/features/onboarding_screen/splash_screen.dart';
import 'package:comet/features/onboarding_screen/parent_screen.dart'; // صفحة الـ OnboardingParentScreen
import 'package:comet/features/login/ui/login_screen.dart';
import 'package:comet/features/login/login_binding.dart';
// استيراد صفحة الهوم (بناءً على الصفحة المؤقتة التي تحدثنا عنها)
// import 'package:comet/features/home/ui/home_screen.dart';

class AppRoutes {
  // أسماء المسارات
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';

  static List<GetPage> routes = [
    // 1. صفحة السبلاش
    GetPage(name: splash, page: () => const SplashScreen()),
    // 2. صفحة الـ Onboarding (التي تحتوي الـ 3 صفحات)
    GetPage(name: onboarding, page: () => const OnboardingParentScreen()),
    // 3. صفحة تسجيل الدخول مع الربط الخاص بها
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    // 4. صفحة الهوم (تفعليها بعد إنشاء ملفها)
    /* GetPage(
      name: home,
      page: () => const HomeScreen(),
    ), */
  ];
}
