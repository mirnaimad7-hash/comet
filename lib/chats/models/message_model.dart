import 'package:get/get.dart';

class MessageModel {
  final String text;
  final String time;
  final bool isSender;
  final bool isImage;
  final bool isAudio;
  final bool isVideo;
  final bool isFile;
  final String mediaUrl;
  final String? localImagePath;
  final String? localVideoPath;
  final String? localFilePath;
  final String? fileName;
  final String? fileSize;
  final String audioDuration;
  final String replyTo;
  final String replyUser;
  final RxBool isRead;
  final RxString reaction;
  final String? localAudioPath;
  final String? senderName;
  final String? senderAvatar;

  MessageModel({
    this.senderName,
    this.senderAvatar,
    this.text = "",
    required this.time,
    required this.isSender,
    this.isImage = false,
    this.isAudio = false,
    this.isVideo = false,
    this.isFile = false,
    this.mediaUrl = "",
    this.localImagePath,
    this.localVideoPath,
    this.localFilePath,
    this.fileName,
    this.fileSize,
    this.audioDuration = "",
    this.replyTo = "",
    this.replyUser = "",
    bool isRead = false,
    this.localAudioPath,
    String reaction = "",
  }) : isRead = isRead.obs,
       reaction = reaction.obs;
}
