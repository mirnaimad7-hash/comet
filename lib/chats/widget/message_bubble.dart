// ignore_for_file: dead_code

import 'dart:io';
import 'package:comet/chats/chats_controller.dart';
import 'package:comet/chats/widget/image_viewer.dart';
import 'package:comet/chats/widget/video_player_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final VoidCallback onReply;
  final ChatController controller;

  MessageBubble({
    super.key,
    required this.message,
    required this.onReply,
    required this.controller,
  });

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

                // الوقت + صح القراءة
                Padding(
                  padding: const EdgeInsets.only(top: 3, left: 4, right: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.time,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                      if (message.isSender) ...[
                        const SizedBox(width: 4),
                        Obx(
                          () => Icon(
                            Icons.done_all,
                            size: 16,
                            color: message.isRead.value
                                ? Colors.blueAccent
                                : Colors.grey[400],
                          ),
                        ),
                      ],
                    ],
                  ),
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
    } else if (message.isVideo == true && message.localVideoPath != null) {
      return VideoPlayerBubble(
        videoPath: message.localVideoPath!,
        isSender: message.isSender,
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
    } else if (message.isFile == true) {
      return _buildFileBubble();
    } else {
      return Text(
        message.text,
        style: TextStyle(color: message.isSender ? Colors.white : Colors.black),
      );
    }
  }

  Widget _buildFileBubble() {
    final name = message.fileName ?? "File";
    final size = message.fileSize ?? "";
    final ext = name.contains('.') ? name.split('.').last.toUpperCase() : "FILE";

    // Pick icon color based on extension
    Color extColor;
    IconData extIcon;
    switch (ext.toLowerCase()) {
      case 'pdf':
        extColor = Colors.red;
        extIcon = Icons.picture_as_pdf;
        break;
      case 'doc':
      case 'docx':
        extColor = Colors.blue;
        extIcon = Icons.article;
        break;
      case 'xls':
      case 'xlsx':
        extColor = Colors.green;
        extIcon = Icons.table_chart;
        break;
      case 'ppt':
      case 'pptx':
        extColor = Colors.orange;
        extIcon = Icons.slideshow;
        break;
      case 'zip':
      case 'rar':
        extColor = Colors.purple;
        extIcon = Icons.folder_zip;
        break;
      default:
        extColor = Colors.grey;
        extIcon = Icons.insert_drive_file;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: message.isSender
                ? Colors.white.withOpacity(0.25)
                : extColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            extIcon,
            color: message.isSender ? Colors.white : extColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: message.isSender ? Colors.white : Colors.black87,
                ),
              ),
              if (size.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  '$ext • $size',
                  style: TextStyle(
                    fontSize: 11,
                    color: message.isSender
                        ? Colors.white70
                        : Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
