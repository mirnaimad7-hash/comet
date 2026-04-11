// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:comet/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OnboardingPage2Content extends StatelessWidget {
  final PageController? controller;
  const OnboardingPage2Content({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),

        _buildHeader(),
        const SizedBox(height: 20),

        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: -10,
                left: -10,
                child: _buildBlurCircle(AppColors.vibrantEnd.withOpacity(0.2)),
              ),
              Positioned(
                bottom: -10,
                right: -10,
                child: _buildBlurCircle(
                  AppColors.vibrantStart.withOpacity(0.1),
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 40,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset('assets/man.jpg', fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 30,
                right: 40,
                child: _buildGlassBox(
                  const Icon(Icons.auto_awesome, color: AppColors.vibrantStart),
                ),
              ),

              Positioned(
                bottom: 80,
                left: 20,
                child: _buildGlassBox(
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.vibrantEnd,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.videocam,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 40,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurfaceColor,
                    height: 1.1,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                  children: [
                    TextSpan(text: 'Create Your \n'),
                    TextSpan(
                      text: 'Legacy.',
                      style: TextStyle(color: AppColors.vibrantStart),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Share your stories, post updates, and express yourself with advanced smart features.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textGrey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildBentoItem(Icons.edit_square, 'EDITORIAL'),
                  const SizedBox(width: 12),
                  _buildBentoItem(Icons.history_edu, 'TIMELINE'),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.flare, color: AppColors.vibrantStart),
              const SizedBox(width: 8),
              const Text(
                'Comet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              print("Skip Pressed");
              controller?.animateToPage(
                2,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'SKIP',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.6),
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassBox(Widget child) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20),
        ],
      ),
      child: child,
    );
  }

  Widget _buildBentoItem(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.vibrantStart, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Color(0xFF494453),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlurCircle(Color color) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 100,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}
