// ignore_for_file: file_names, deprecated_member_use

import 'dart:io';
import 'package:comet/core/theme/app_colors.dart';
import 'package:comet/chats/chatsAndGroups_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupInfoPage extends StatelessWidget {
  final LocalGroupModel group;

  const GroupInfoPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.onSurfaceColor,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Group Info",
          style: TextStyle(
            color: AppColors.onSurfaceColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المجموعة الواضحة تماماً بدون أي تغبيش
            Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: AppColors.babyblue,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondaryNeon.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  image: group.avatar.isNotEmpty
                      ? DecorationImage(
                          image: group.avatar.startsWith('http')
                              ? NetworkImage(group.avatar) as ImageProvider
                              : FileImage(File(group.avatar)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: group.avatar.isEmpty
                    ? const Center(
                        child: Icon(
                          Icons.blur_on,
                          color: AppColors.secondaryNeon,
                          size: 45,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            // اسم المجموعة والتاج
            Center(
              child: Column(
                children: [
                  Text(
                    group.name,
                    style: const TextStyle(
                      color: AppColors.onSurfaceColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  if (group.tag.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryNeon.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        group.tag,
                        style: const TextStyle(
                          color: AppColors.secondaryNeon,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // قسم الوصف
            const Text(
              "Description",
              style: TextStyle(
                color: AppColors.secondaryNeon,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                group.desc,
                style: const TextStyle(
                  color: AppColors.darkblue,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // قسم عدد الأعضاء
            const Text(
              "Members",
              style: TextStyle(
                color: AppColors.secondaryNeon,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.group_outlined,
                    color: AppColors.secondaryNeon,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    group.members,
                    style: const TextStyle(
                      color: AppColors.onSurfaceColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // خيار حذف أو مغادرة المجموعة
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.1),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  // منطق الحذف أو الخروج
                  Get.back();
                  Get.back();
                  Get.snackbar(
                    "تنبيه",
                    "تمت مغادرة المجموعة",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: const Text(
                  "Exit / Delete Group",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
