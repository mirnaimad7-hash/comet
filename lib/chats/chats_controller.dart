// ignore_for_file: unused_import, unused_field, prefer_final_fields, empty_statements, must_call_super

import 'dart:io';
import 'package:comet/chats/models/message_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  final FlutterSoundRecorder recorder = FlutterSoundRecorder();

  var messages = <MessageModel>[].obs;
  var isWriting = false.obs;
  var isRecording = false.obs;
  String? lastRecordedPath;
  RxBool isPlaying = false.obs;
  var replyingToMessage = Rxn<MessageModel>();
  var recordDuration = "0:00".obs;

  Stopwatch _stopwatch = Stopwatch();

  @override
  void onInit() {
    super.onInit();
    _initRecorder();

    messages.addAll([
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
    ]);

    messageController.addListener(() {
      isWriting.value = messageController.text.trim().isNotEmpty;
    });
  }

  Future<void> _initRecorder() async {
    await recorder.openRecorder();
  }

  Future<void> toggleRecording() async {
    if (isRecording.value) {
      lastRecordedPath = await recorder.stopRecorder();
      isRecording.value = false;
      _stopwatch.stop();

      messages.add(
        MessageModel(
          time: _getCurrentTime(),
          isSender: true,
          isAudio: true,
          audioDuration: recordDuration.value,
          localAudioPath: lastRecordedPath,
        ),
      );

      recordDuration.value = "0:00";
      scrollToBottom();
    } else {
      if (await Permission.microphone.request().isGranted) {
        String path = 'audio_${DateTime.now().millisecondsSinceEpoch}.aac';
        await recorder.startRecorder(toFile: path);

        isRecording.value = true;
        lastRecordedPath = path;

        _stopwatch.reset();
        _stopwatch.start();

        Future.doWhile(() async {
          await Future.delayed(const Duration(seconds: 1));
          if (isRecording.value) {
            int seconds = _stopwatch.elapsed.inSeconds;
            recordDuration.value =
                "${(seconds ~/ 60)}:${(seconds % 60).toString().padLeft(2, '0')}";
          }
          return isRecording.value;
        });
      } else {
        Get.snackbar("خطأ", "يجب السماح بالوصول للميكروفون");
      }
    }
  }

  void setReplyTo(MessageModel message) => replyingToMessage.value = message;
  void cancelReply() => replyingToMessage.value = null;
  void markMessagesAsRead() {
    for (var message in messages) {
      if (!message.isRead.value) {
        message.isRead.value = true;
      }
    }
  }

  void handleSendMessage() {
    if (messageController.text.trim().isEmpty) return;

    messages.add(
      MessageModel(
        text: messageController.text.trim(),
        time: _getCurrentTime(),
        isSender: true,
        replyTo: replyingToMessage.value?.text ?? "",
        replyUser: replyingToMessage.value != null ? "User" : "",
      ),
    );

    messageController.clear();
    cancelReply();
    scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour > 12 ? now.hour - 12 : now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";
  }

  Future<void> pickMedia(bool fromCamera) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (image != null) {
      messages.add(
        MessageModel(
          time: _getCurrentTime(),
          isSender: true,
          isImage: true,
          localImagePath: image.path,
        ),
      );
      scrollToBottom();
    }
  }

  Future<void> pickFiles() async {
    final result = await FilePicker.pickFiles();

    if (result != null) {
      print("تم اختيار ملف: ${result.files.single.name}");
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    recorder.closeRecorder();
  }

  Future<void> initPlayer() async {
    await _player.openPlayer();
  }

  Future<void> playAudio(String path) async {
    if (isPlaying.value) {
      await _player.stopPlayer();
      isPlaying.value = false;
    } else {
      isPlaying.value = true;
      await _player.startPlayer(
        fromURI: path,
        whenFinished: () {
          isPlaying.value = false;
        },
      );
    }
  }
}
