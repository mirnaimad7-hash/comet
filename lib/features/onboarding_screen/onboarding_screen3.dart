// ignore_for_file: unused_import, use_super_parameters, deprecated_member_use

import 'package:comet/features/login/ui/login_screen.dart';
import 'package:comet/features/onboarding_screen/onboarding_screen1.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:comet/core/theme/app_colors.dart';
import 'onboarding_screen2.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

class OnboardingParentScreen extends StatefulWidget {
  const OnboardingParentScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingParentScreen> createState() => _OnboardingParentScreenState();
}

class _OnboardingParentScreenState extends State<OnboardingParentScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.vibrantEnd,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          _buildStaticBackground(),
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: 3,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const OnboardingPage1Content();
              }
              if (index == 1) {
                return const OnboardingPage2Content();
              }
              if (index == 2) {
                return const OnboardingPageContent();
              }
              return const SizedBox();
            },
          ),

          _buildFixedBottomSection(context),
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
          top: 20,
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

  Widget _buildFixedBottomSection(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 32,
      right: 32,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) => _buildDot(index)),
          ),
          const SizedBox(height: 16),
          if (_currentPage != 1)
            GestureDetector(
              onTap: () {
                if (_currentPage == 2) {
                  print("الانتقال لصفحة التسجيل");
                } else {
                  _pageController.nextPage(
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
                    colors: _currentPage == 2
                        ? [AppColors.vibrantEnd, const Color(0xFF00677E)]
                        : [AppColors.vibrantStart, AppColors.purple],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (_currentPage == 2
                                  ? AppColors.vibrantEnd
                                  : AppColors.vibrantStart)
                              .withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _currentPage == 2 ? "Get Started" : "Next",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            )
          else
            const SizedBox(height: 64),
          const SizedBox(height: 24),

          Visibility(
            visible: _currentPage == 2,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: TextButton(
              onPressed: () {
                Get.to(() => const LoginScreen());
                print("الانتقال لصفحة تسجيل الدخول");
              },
              child: Text(
                'ALREADY HAVE AN ACCOUNT? LOG IN',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceColor.withOpacity(0.45),
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    bool isActive = (index == _currentPage);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 36 : 9,
      height: 9,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.vibrantEnd
            : AppColors.purple.withOpacity(0.3),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 60),

          _buildIllustration(),
          const SizedBox(height: 70),

          _buildTextContent(),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return SizedBox(
      width: 320,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: 45 * math.pi / 180,
            child: Container(
              width: 280,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.purple.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(150),
              ),
            ),
          ),

          Transform.rotate(
            angle: -12 * math.pi / 180,
            child: Container(
              width: 310,
              height: 310,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.purple.withOpacity(0.1)),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.vibrantStart, AppColors.vibrantEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.vibrantStart.withOpacity(0.4),
                  blurRadius: 50,
                  offset: const Offset(0, 20),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 3,
              ),
            ),
            child: const Icon(Icons.flare, color: Colors.white, size: 90),
          ),

          Positioned(
            top: 30,
            right: 40,
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.cloudy_snowing,
                color: Color(0xFF00677E),
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        children: [
          Text(
            'Your Journey',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurfaceColor,
              fontFamily: 'Plus Jakarta Sans',
              height: 1.1,
            ),
          ),

          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.vibrantStart, AppColors.vibrantEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: const Text(
              'Starts Here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontFamily: 'Plus Jakarta Sans',
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Experience the next-gen social\nplatform built for you.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              color: AppColors.onSurfaceColor.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
