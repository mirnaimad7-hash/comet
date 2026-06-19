// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class LinkedPostBanner extends StatelessWidget {
  const LinkedPostBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.babyblue.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(color: AppColors.white.withOpacity(0.4)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.link, size: 16, color: AppColors.secondaryNeon),
              const SizedBox(width: 8),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 12, fontFamily: 'Inter'),
                  children: [
                    TextSpan(
                      text: "Linked to: ",
                      style: TextStyle(
                        color: AppColors.darkblue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: "Midnight in Tokyo",
                      style: TextStyle(
                        color: AppColors.secondaryNeon,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Icon(Icons.chevron_right, size: 18, color: AppColors.textGrey),
        ],
      ),
    );
  }
}
