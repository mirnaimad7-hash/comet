// ignore_for_file: unused_import, curly_braces_in_flow_control_structures, use_super_parameters, deprecated_member_use

import 'package:comet/core/routing/app_router.dart';
import 'package:comet/features/login/ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:comet/core/theme/app_colors.dart';
import 'onboarding_screen1.dart';
import 'onboarding_screen2.dart';
import 'onboarding_screen3.dart';
import 'onboarding_controller.dart';

class OnboardingParentScreen extends StatelessWidget {
  const OnboardingParentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OnboardingController controller = Get.put(OnboardingController());
    final PageController pageController = PageController();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          _buildStaticBackground(),

          PageView.builder(
            controller: pageController,
            onPageChanged: controller.updatePage,
            itemCount: 3,
            itemBuilder: (context, index) {
              if (index == 0)
                return OnboardingPage1Content(controller: pageController);
              if (index == 1)
                return OnboardingPage2Content(controller: pageController);
              return const OnboardingPageContent();
            },
          ),

          _buildFixedBottomSection(context, controller, pageController),
        ],
      ),
    );
  }

  Widget _buildStaticBackground() {
    return Stack(
      children: [
        Positioned(
          bottom: -150,
          left: -150,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.04),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 30,
          left: 0,
          right: 0,
          child: Text(
            'Comet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.w900,
              color: AppColors.purple.withOpacity(0.12),
              letterSpacing: -6,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFixedBottomSection(
    BuildContext context,
    OnboardingController controller,
    PageController pageController,
  ) {
    return Positioned(
      bottom: 24,
      left: 32,
      right: 32,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => _buildDot(index, controller.currentPage.value),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Obx(
            () => controller.currentPage.value == 1
                ? const SizedBox(height: 64)
                : GestureDetector(
                    onTap: () {
                      if (controller.currentPage.value == 2) {
                        Get.offAllNamed(AppRoutes.login);
                        print("الانتقال لصفحة التسجيل");
                      } else {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: LinearGradient(
                          colors: controller.currentPage.value == 2
                              ? [AppColors.vibrantEnd, const Color(0xFF00677E)]
                              : [AppColors.primaryColor, AppColors.purple],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (controller.currentPage.value == 2
                                        ? AppColors.vibrantEnd
                                        : AppColors.primaryColor)
                                    .withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          controller.currentPage.value == 2
                              ? "Get Started"
                              : "Next",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),

          const SizedBox(height: 24),

          Obx(
            () => Visibility(
              visible: controller.currentPage.value == 2,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: TextButton(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.login);
                  print("الانتقال لصفحة تسجيل الدخول");
                },
                child: Text(
                  'ALREADY HAVE AN ACCOUNT? LOG IN',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0B1C30).withOpacity(0.45),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, int currentPage) {
    bool isActive = (index == currentPage);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 36 : 9,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.vibrantEnd
            : AppColors.gradientLightBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
