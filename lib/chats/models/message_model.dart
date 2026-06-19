import 'package:get/get.dart';

class MessageModel {
  final String text;
  final String time;
  final bool isSender;
  final bool isImage;
  final bool isAudio;
  final String mediaUrl;
  final String? localImagePath;
  final String audioDuration;
  final String replyTo;
  final String replyUser;
  final RxBool isRead;
  final RxString reaction;
  final String? localAudioPath;

  MessageModel({
    this.text = "",
    required this.time,
    required this.isSender,
    this.isImage = false,
    this.isAudio = false,
    this.mediaUrl = "",
    this.localImagePath,
    this.audioDuration = "",
    this.replyTo = "",
    this.replyUser = "",
    bool isRead = false,
    this.localAudioPath,
    String reaction = "",
  }) : isRead = isRead.obs,
       reaction = reaction.obs;
}
