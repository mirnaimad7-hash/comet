// ignore_for_file: depend_on_referenced_packages, duplicate_import, unused_import

import 'package:comet/assets/app_translation.dart';
import 'package:comet/core/routing/app_router.dart';
import 'package:comet/features/login/login_binding.dart';
import 'package:comet/features/login/ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:comet/features/onboarding_screen/splash_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CometApp());
}

class CometApp extends StatelessWidget {
  const CometApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Comet',
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}
