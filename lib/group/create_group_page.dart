// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:comet/group/create_group_controller.dart';
import 'package:comet/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGroupPage extends StatelessWidget {
  CreateGroupPage({super.key});

  final CreateGroupController controller = Get.put(CreateGroupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondaryNeon),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Create Group",
          style: TextStyle(
            color: AppColors.onSurfaceColor,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textGrey),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderBanner(context),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel("GROUP NAME"),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.nameController,
                    hintText: "e.g. Celestial Explorers",
                  ),
                  const SizedBox(height: 20),
                  _buildSectionLabel("GROUP DESCRIPTION"),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.descriptionController,
                    hintText: "Tell the world what this space is for...",
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionLabel("PRIVACY LEVEL"),
                  const SizedBox(height: 8),
                  _buildPrivacyToggle(),
                  const SizedBox(height: 8),
                  Text(
                    "Public groups appear in search and anyone can join. Private groups require an invitation.",
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionLabel("ADD MEMBERS"),
                  const SizedBox(height: 8),
                  _buildSearchMemberField(),
                  const SizedBox(height: 20),
                  _buildSectionLabel("Suggested Curators"),
                  const SizedBox(height: 12),
                  _buildSuggestedCurators(),
                  const SizedBox(height: 32),
                  _buildCreateButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // غلاف المجموعة (Cover Photo)
          Obx(
            () => Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.babyblue,
                borderRadius: BorderRadius.circular(24),
                image: controller.coverPhotoPath.value.isNotEmpty
                    ? DecorationImage(
                        image: FileImage(File(controller.coverPhotoPath.value)),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: NetworkImage(
                          "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600",
                        ),
                        fit: BoxFit.cover,
                      ),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: controller.pickCoverPhoto,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.camera_alt,
                          color: AppColors.white,
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "ADD COVER PHOTO",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // زر تعديل الغلاف الجانبي الصغير
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: controller.pickCoverPhoto,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.secondaryNeon,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: AppColors.white, size: 16),
              ),
            ),
          ),
          // أيقونة المجموعة المربعة العائمة (Group Icon)
          Positioned(
            bottom: -30,
            left: 20,
            child: Obx(
              () => GestureDetector(
                onTap: controller.pickGroupIcon,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.babyblue,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: controller.groupIconPath.value.isNotEmpty
                        ? DecorationImage(
                            image: FileImage(
                              File(controller.groupIconPath.value),
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: controller.groupIconPath.value.isEmpty
                      ? const Center(
                          child: Icon(
                            Icons.blur_on,
                            color: AppColors.secondaryNeon,
                            size: 36,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.secondaryNeon,
        fontWeight: FontWeight.bold,
        fontSize: 11,
        letterSpacing: 1.2,
        fontFamily: 'Plus Jakarta Sans',
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.babyblue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 15, color: AppColors.onSurfaceColor),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.textGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyToggle() {
    return Obx(
      () => Container(
        height: 54,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.babyblue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.isPublic.value = true,
                child: Container(
                  decoration: BoxDecoration(
                    color: controller.isPublic.value
                        ? AppColors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: controller.isPublic.value
                        ? [
                            BoxShadow(
                              color: AppColors.secondaryNeon.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      "Public",
                      style: TextStyle(
                        color: controller.isPublic.value
                            ? AppColors.secondaryNeon
                            : AppColors.darkblue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.isPublic.value = false,
                child: Container(
                  decoration: BoxDecoration(
                    color: !controller.isPublic.value
                        ? AppColors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: !controller.isPublic.value
                        ? [
                            BoxShadow(
                              color: AppColors.secondaryNeon.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      "Private",
                      style: TextStyle(
                        color: !controller.isPublic.value
                            ? AppColors.secondaryNeon
                            : AppColors.darkblue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchMemberField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.babyblue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller.searchMemberController,
        style: const TextStyle(fontSize: 15, color: AppColors.onSurfaceColor),
        decoration: InputDecoration(
          hintText: "Search friends...",
          hintStyle: TextStyle(
            color: AppColors.textGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textGrey,
            size: 22,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSuggestedCurators() {
    final List<Map<String, String>> curators = [
      {
        "name": "Julian V.",
        "img":
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80",
      },
      {
        "name": "Amara L.",
        "img":
            "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=80",
      },
      {
        "name": "Elena R.",
        "img":
            "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=80",
      },
      {
        "name": "Marcus K.",
        "img":
            "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=80",
      },
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: curators.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final curator = curators[index];
          return Obx(() {
            bool isSelected = controller.selectedMembers.contains(
              curator["name"],
            );
            return GestureDetector(
              onTap: () => controller.toggleMemberSelection(curator["name"]!),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [
                                AppColors.secondaryNeon,
                                AppColors.accentCyan,
                              ],
                            )
                          : null,
                      border: !isSelected
                          ? Border.all(color: Colors.transparent)
                          : null,
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(curator["img"]!),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    curator["name"]!,
                    style: const TextStyle(
                      color: AppColors.onSurfaceColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildCreateButton() {
    return GestureDetector(
      onTap: controller.createGroup,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.secondaryNeon, AppColors.primaryNeon],
          ),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryNeon.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: const Center(
          child: Text(
            "Create Group",
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ),
      ),
    );
  }
}
