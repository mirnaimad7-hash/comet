// ignore_for_file: file_names, deprecated_member_use

import 'dart:io';
import 'package:comet/core/theme/app_colors.dart';
import 'package:comet/chats/chatsAndGroups_page.dart';
import 'package:comet/chats/widget/chat_input_bar.dart';
import 'package:comet/chats/widget/message_bubble.dart';
import 'package:comet/group/Group_chat_controller.dart';
import 'package:comet/group/group_info_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../chats/chats_controller.dart';

class GroupChatPage extends StatelessWidget {
  final LocalGroupModel group;
  late final GroupChatController controller;

  GroupChatPage({super.key, required this.group}) {
    if (!Get.isRegistered<GroupChatController>(tag: group.name)) {
      Get.put(GroupChatController(), tag: group.name);
    }
    controller = Get.find<GroupChatController>(tag: group.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: AppColors.white,
          elevation: 2,
          shadowColor: AppColors.secondaryNeon.withOpacity(0.05),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.onSurfaceColor,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
          title: GestureDetector(
            onTap: () => Get.to(() => GroupInfoPage(group: group)),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.babyblue,
                    borderRadius: BorderRadius.circular(12),
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
                            size: 20,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        group.name,
                        style: const TextStyle(
                          color: AppColors.onSurfaceColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        group.members,
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: AppColors.onSurfaceColor,
              ),
              onPressed: () => Get.to(() => GroupInfoPage(group: group)),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(20),
                itemCount: controller.messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.babyblue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "You created this group: ${group.name}",
                          style: const TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    );
                  }

                  final msg = controller.messages[index - 1];

                  // إذا كانت الرسالة ليست من المرسل الحالي (أي من عضو آخر في الغروب)، نعرض صورته واسمه فوق فقاعة الرسالة
                  if (!msg.isSender && msg.senderName != null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(
                              msg.senderAvatar ??
                                  "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80",
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg.senderName!,
                                  style: const TextStyle(
                                    color: AppColors.secondaryNeon,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // استخدام MessageBubble المعتاد لعرض محتوى الرسالة (صورة، صوت، ملف، نص)
                                MessageBubble(
                                  message: msg,
                                  controller: controller as ChatController,
                                  onReply: () => controller.setReplyTo(msg),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return MessageBubble(
                    message: msg,
                    controller: controller as ChatController,
                    onReply: () => controller.setReplyTo(msg),
                  );
                },
              ),
            ),
          ),

          ChatInputBar(controller: controller as ChatController),
        ],
      ),
    );
  }
}
