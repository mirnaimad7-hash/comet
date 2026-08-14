// ignore_for_file: unused_import

import 'dart:io';
import 'package:comet/chats/chats_controller.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatInputBar extends StatefulWidget {
  final ChatController controller;
  const ChatInputBar({super.key, required this.controller});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool isEmojiVisible = false;
  late final ChatController controller = widget.controller;

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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(Icons.camera_alt, color: Colors.blue),
              ),
              title: const Text("كاميرا - صورة"),
              onTap: () {
                Navigator.pop(ctx);
                controller.pickMedia(true);
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(Icons.videocam, color: Colors.green),
              ),
              title: const Text("كاميرا - فيديو"),
              onTap: () {
                Navigator.pop(ctx);
                controller.pickVideo(true);
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFF3E5F5),
                child: Icon(Icons.photo_library, color: Colors.purple),
              ),
              title: const Text("المعرض - صورة"),
              onTap: () {
                Navigator.pop(ctx);
                controller.pickMedia(false);
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFFF3E0),
                child: Icon(Icons.video_library, color: Colors.orange),
              ),
              title: const Text("المعرض - فيديو"),
              onTap: () {
                Navigator.pop(ctx);
                controller.pickVideo(false);
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFFEBEE),
                child: Icon(Icons.insert_drive_file, color: Colors.red),
              ),
              title: const Text("ملفات"),
              onTap: () {
                Navigator.pop(ctx);
                controller.pickFiles();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
