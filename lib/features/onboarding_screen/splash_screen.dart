// ignore_for_file: unused_import, use_super_parameters, deprecated_member_use, depend_on_referenced_packages
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:comet/core/theme/app_colors.dart';
import 'package:comet/features/onboarding_screen/onboarding_screen1.dart';
import 'package:comet/features/onboarding_screen/parent_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {});
      });

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Timer(const Duration(milliseconds: 500), () {
          Get.off(() => const OnboardingParentScreen());
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.gradientLightPurple,
              Colors.white,
              AppColors.gradientLightBlue,
            ],
          ),
        ),
        child: Stack(
          children: [
            _buildFloatingElement(top: 80, right: 40, child: _buildUserCard()),
            _buildFloatingElement(bottom: 150, left: -20, child: _buildChartCard()),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMainLogo(),
                  const SizedBox(height: 30),
                  const Text(
                    'Comet',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: AppColors.vibrantStart,
                      fontFamily: 'Plus Jakarta Sans',
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'CONNECT. CREATE. COMET.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.5),
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 60,
              left: 50,
              right: 50,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _animation.value,
                      minHeight: 4,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFC0A6F3)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'INITIALISING EXPERIENCE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 30,
              right: 30,
              child: Opacity(
                opacity: 0.3,
                child: Row(
                  children: const [
                    Icon(Icons.flare, size: 16),
                    SizedBox(width: 4),
                    Text('Comet', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildMainLogo() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.flare, size: 60, color: AppColors.vibrantStart),
          ),
        ),
        Positioned(
          top: -10,
          right: -10,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color:AppColors.vibrantEnd,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingElement({double? top, double? bottom, double? left, double? right, required Widget child}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Opacity(
        opacity: 0.4,
        child: child,
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 35, height: 35, decoration: const BoxDecoration(color: AppColors.surfaceColor, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 50, height: 8, decoration: BoxDecoration(color: AppColors.surfaceColor, borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 4),
              Container(width: 30, height: 8, decoration: BoxDecoration(color: AppColors.surfaceColor, borderRadius: BorderRadius.circular(4))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    return Container(
      width: 180,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomPaint(painter: _ChartPainter()),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.vibrantEnd.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.8, size.width * 0.6, size.height * 0.4);
    path.lineTo(size.width, size.height * 0.2);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}