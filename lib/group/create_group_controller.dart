// ignore_for_file: unused_import

import 'dart:io';
import 'package:comet/chats/chatsAndGroups_page.dart'; // لتحديث القائمة العامة
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchMemberController = TextEditingController();

  var isPublic = true.obs;
  var coverPhotoPath = ''.obs;
  var groupIconPath = ''.obs;
  var selectedMembers = <String>[].obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickCoverPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      coverPhotoPath.value = image.path;
    }
  }

  Future<void> pickGroupIcon() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      groupIconPath.value = image.path;
    }
  }

  void toggleMemberSelection(String memberName) {
    if (selectedMembers.contains(memberName)) {
      selectedMembers.remove(memberName);
    } else {
      selectedMembers.add(memberName);
    }
  }

  void createGroup() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        "خطأ",
        "يرجى إدخال اسم المجموعة",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final newGroup = LocalGroupModel(
      name: nameController.text.trim(),
      desc: descriptionController.text.trim().isEmpty
          ? "No description provided."
          : descriptionController.text.trim(),
      tag: "Admin",
      members: "${selectedMembers.length + 1} members",
      avatar: groupIconPath.value.isNotEmpty
          ? groupIconPath.value
          : coverPhotoPath.value,
    );

    if (Get.isRegistered<ChatsAndGroupsController>()) {
      final groupsController = Get.find<ChatsAndGroupsController>();
      groupsController.groupsData.insert(0, newGroup);
    }

    Get.snackbar(
      "نجاح",
      "تم إنشاء المجموعة بنجاح!",
      snackPosition: SnackPosition.BOTTOM,
    );

    Get.back();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    searchMemberController.dispose();
    super.dispose();
  }
}
