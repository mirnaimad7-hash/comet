import 'package:comet/chats/chats_controller.dart';
import 'package:comet/chats/widget/chat_app_bar.dart';
import 'package:comet/chats/widget/chat_input_bar.dart';
import 'package:comet/chats/widget/linked_post_banner.dart';
import 'package:comet/chats/widget/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final bool isOnline;

  // كل محادثة عندها tag بـ userName عشان تحتفظ برسائلها
  late final ChatController controller;

  ChatPage({
    super.key,
    required this.userName,
    required this.userAvatar,
    this.isOnline = true,
  }) {
    // لو في controller لهاد الشخص نستخدمه، لو لا نعمل جديد
    if (!Get.isRegistered<ChatController>(tag: userName)) {
      Get.put(ChatController(), tag: userName);
    }
    controller = Get.find<ChatController>(tag: userName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        userName: userName,
        userAvatar: userAvatar,
        isOnline: isOnline,
      ),
      body: Column(
        children: [
          const LinkedPostBanner(),
          Expanded(
            child: Obx(
              () => ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return MessageBubble(
                    message: msg,
                    controller: controller,
                    onReply: () => controller.setReplyTo(msg),
                  );
                },
              ),
            ),
          ),
          ChatInputBar(controller: controller),
        ],
      ),
    );
  }
}
