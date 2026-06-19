// ignore_for_file: dead_code

import 'dart:io';
import 'package:comet/chats/chats_controller.dart';
import 'package:comet/chats/widget/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final VoidCallback onReply;
  final ChatController controller = Get.find();

  MessageBubble({super.key, required this.message, required this.onReply});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(message.hashCode),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => onReply(),
      background: const Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Icon(Icons.reply, color: Colors.blueAccent),
        ),
      ),
      child: GestureDetector(
        onLongPress: () {
          Get.bottomSheet(
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ["👍🏻", "❤️", "😭", "😂", "😡", "😍"].map((
                      emoji,
                    ) {
                      return GestureDetector(
                        onTap: () {
                          message.reaction.value = emoji;
                          Get.back();
                        },
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 30),
                        ),
                      );
                    }).toList(),
                  ),
                  const Divider(height: 30),
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text("حذف الرسالة"),
                    onTap: () {
                      controller.messages.remove(message);
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          );
        },
        child: Align(
          alignment: message.isSender
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
            child: Column(
              crossAxisAlignment: message.isSender
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isSender
                        ? Colors.blueAccent
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _buildMessageContent(),
                ),

                Obx(
                  () => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: message.reaction.value.isNotEmpty
                        ? Container(
                            key: ValueKey(message.reaction.value),
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 4),
                              ],
                            ),
                            child: Text(
                              message.reaction.value,
                              style: const TextStyle(fontSize: 18),
                            ),
                          )
                        : const SizedBox.shrink(key: ValueKey("empty")),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    if (message.isAudio == true) {
      return GestureDetector(
        onTap: () => controller.playAudio(message.localAudioPath ?? ""),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
            const SizedBox(width: 8),
            Text(
              message.audioDuration,
              style: TextStyle(
                color: message.isSender ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      );
    } else if (message.isImage == true && message.localImagePath != null) {
      return GestureDetector(
        onTap: () =>
            Get.to(() => ImageViewer(imagePath: message.localImagePath!)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(File(message.localImagePath!), width: 200),
        ),
      );
    } else {
      return Text(
        message.text,
        style: TextStyle(color: message.isSender ? Colors.white : Colors.black),
      );
    }
  }
}
