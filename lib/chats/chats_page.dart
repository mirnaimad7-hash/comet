// ignore_for_file: unused_import, unnecessary_null_comparison

import 'package:comet/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  final String userAvatar;
  final bool isOnline;

  const ChatPage({
    super.key,
    required this.userName,
    required this.userAvatar,
    this.isOnline = true,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<MessageModel> _messages = [
    MessageModel(
      text: "Did you see the latest concept for the editorial shoot?",
      time: "09:41 AM",
      isSender: false,
    ),
    MessageModel(
      text:
          "Just checked it out. The lighting in the third shot is incredible! ✨",
      time: "09:42 AM",
      isSender: true,
    ),
    MessageModel(
      text:
          "Exactly! I'm planning to use a similar setup for the Comet campaign launch next week.",
      time: "09:44 AM",
      isSender: false,
      replyTo: "The lighting in the third shot is incredible! ✨",
      replyUser: "Elena Vance",
    ),
    MessageModel(
      time: "09:45 AM",
      isSender: true,
      isImage: true,
      mediaUrl:
          "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=500",
    ),
    MessageModel(
      time: "09:46 AM",
      isSender: false,
      isAudio: true,
      audioDuration: "0:24",
    ),
  ];

  bool _isWriting = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        _isWriting = _messageController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        MessageModel(
          text: _messageController.text.trim(),
          time:
              "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
          isSender: true,
        ),
      );
      _messageController.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _pickMedia(bool fromCamera) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (image != null) {}

    Get.snackbar(
      "Comet Media",
      fromCamera ? "Opening Camera..." : "Opening Photo Gallery...",
    );
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.pickFiles();
    if (result != null) {}

    Get.snackbar("Comet Files", "Opening File Browser...");
  }

  void _toggleAudioRecording() {
    Get.snackbar(
      "Comet Audio",
      _isWriting ? "Sending Text..." : "Holding to record voice message...",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: _buildChatAppBar(),
      body: Stack(
        children: [
          _buildBackgroundWatermark(),
          Column(
            children: [
              _buildLinkedPostBanner(),

              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return _buildMessageBubble(message);
                  },
                ),
              ),
              _buildBottomInputBar(),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildChatAppBar() {
    return AppBar(
      backgroundColor: AppColors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.secondaryNeon),
        onPressed: () => Get.back(),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.userAvatar),
              ),
              if (widget.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D2FD),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userName,
                style: const TextStyle(
                  color: AppColors.onSurfaceColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.isOnline ? "ONLINE" : "OFFLINE",
                style: const TextStyle(
                  color: AppColors.secondaryNeon,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam_outlined, color: AppColors.darkblue),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.darkblue),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildLinkedPostBanner() {
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

  Widget _buildMessageBubble(MessageModel message) {
    return Align(
      alignment: message.isSender
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Column(
          crossAxisAlignment: message.isSender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: message.isSender ? null : AppColors.babyblue,
                gradient: message.isSender
                    ? const LinearGradient(
                        colors: [Color(0xFF00D2FD), Color(0xFF3CD7FF)],
                      )
                    : null,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24),
                  topRight: const Radius.circular(24),
                  bottomLeft: message.isSender
                      ? const Radius.circular(24)
                      : Radius.zero,
                  bottomRight: message.isSender
                      ? Radius.zero
                      : const Radius.circular(24),
                ),
                boxShadow: message.isSender
                    ? [
                        BoxShadow(
                          color: const Color(0xFF00D2FD).withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: _buildMessageContent(message),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                message.time,
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(MessageModel message) {
    if (message.isImage) {
      return Image.network(message.mediaUrl, fit: BoxFit.cover);
    }

    if (message.isAudio) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.secondaryNeon,
              child: const Icon(
                Icons.play_arrow,
                color: AppColors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Row(
              children: List.generate(
                8,
                (index) => Container(
                  width: 3,
                  height:
                      (index % 2 == 0 ? 16.0 : 26.0) + (index == 4 ? 10 : 0),
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryNeon.withOpacity(
                      index > 5 ? 0.3 : 1.0,
                    ),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              message.audioDuration,
              style: const TextStyle(
                color: AppColors.onSurfaceColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.replyTo.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.5),
                border: const Border(
                  left: BorderSide(color: AppColors.secondaryNeon, width: 4),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.replyUser,
                    style: const TextStyle(
                      color: AppColors.secondaryNeon,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message.replyTo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
          Text(
            message.text,
            style: TextStyle(
              color: message.isSender
                  ? const Color(0xFF005669)
                  : AppColors.onSurfaceColor,
              fontSize: 15,
              fontWeight: message.isSender
                  ? FontWeight.w500
                  : FontWeight.normal,
              height: 1.4,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInputBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(
              Icons.add_circle,
              color: AppColors.secondaryNeon,
              size: 28,
            ),
            onPressed: () => _showMediaBottomSheet(),
          ),
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.babyblue,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      color: AppColors.textGrey,
                      size: 22,
                    ),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      maxLines: 4,
                      minLines: 1,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.onSurfaceColor,
                      ),
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    icon: Icon(
                      Icons.attach_file,
                      color: AppColors.textGrey,
                      size: 22,
                    ),
                    onPressed: _pickFiles,
                  ),

                  IconButton(
                    icon: Icon(
                      Icons.photo_camera_outlined,
                      color: AppColors.textGrey,
                      size: 22,
                    ),
                    onPressed: () => _pickMedia(true),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isWriting ? _handleSendMessage : _toggleAudioRecording,
            child: CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.secondaryNeon,
              child: Icon(
                _isWriting ? Icons.send : Icons.mic,
                color: AppColors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMediaBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.secondaryNeon,
              ),
              title: const Text(
                "Open Photo Gallery",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Get.back();
                _pickMedia(false);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
                color: AppColors.secondaryNeon,
              ),
              title: const Text(
                "Take Fresh Photo",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Get.back();
                _pickMedia(true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundWatermark() {
    return const Positioned.fill(
      child: IgnorePointer(
        child: Opacity(
          opacity: 0.03,
          child: Center(
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(12 / 360),
              child: Text(
                "COMET",
                style: TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -5,
                  color: AppColors.onSurfaceColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MessageModel {
  final String text;
  final String time;
  final bool isSender;
  final bool isImage;
  final bool isAudio;
  final String mediaUrl;
  final String audioDuration;
  final String replyTo;
  final String replyUser;

  MessageModel({
    this.text = "",
    required this.time,
    required this.isSender,
    this.isImage = false,
    this.isAudio = false,
    this.mediaUrl = "",
    this.audioDuration = "",
    this.replyTo = "",
    this.replyUser = "",
  });
}
