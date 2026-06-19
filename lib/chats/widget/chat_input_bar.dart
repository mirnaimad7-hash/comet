// ignore_for_file: unused_import

import 'dart:io';
import 'package:comet/chats/chats_controller.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool isEmojiVisible = false;
  final ChatController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => controller.replyingToMessage.value != null
              ? _buildReplyBar()
              : const SizedBox(),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  isEmojiVisible
                      ? Icons.keyboard
                      : Icons.emoji_emotions_outlined,
                ),
                onPressed: () =>
                    setState(() => isEmojiVisible = !isEmojiVisible),
              ),

              Expanded(
                child: TextField(
                  controller: controller.messageController,
                  onTap: () => setState(() => isEmojiVisible = false),
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: () => _showMediaOptions(),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),
              Obx(
                () => GestureDetector(
                  onTap: () {
                    if (controller.isWriting.value) {
                      controller.handleSendMessage();
                    } else {
                      controller.toggleRecording();
                    }
                  },
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(
                      controller.isWriting.value
                          ? Icons.send
                          : (controller.isRecording.value
                                ? Icons.stop
                                : Icons.mic),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        if (isEmojiVisible)
          SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                controller.messageController.text += emoji.emoji;
              },
            ),
          ),
      ],
    );
  }

  Widget _buildReplyBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      color: Colors.blue[50],
      child: Row(
        children: [
          const Icon(Icons.reply, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "رد على: ${controller.replyingToMessage.value!.text}",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: () => controller.cancelReply(),
          ),
        ],
      ),
    );
  }

  void _showMediaOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                controller.pickMedia(true);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () {
                controller.pickMedia(false);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text("Files"),
              onTap: () {
                controller.pickFiles();
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
