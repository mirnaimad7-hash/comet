// ignore_for_file: file_names
import 'package:comet/chats/chats_controller.dart';
import 'package:comet/chats/models/message_model.dart';

class GroupChatController extends ChatController {
  @override
  void onInit() {
    super.onInit();

    messages.addAll([
      MessageModel(
        text: "Hey everyone! Welcome to the group.",
        time: "09:41 AM",
        isSender: false,
        senderName: "Julian",
        senderAvatar:
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80",
      ),
      MessageModel(
        text: "Glad to be here! Let's build something amazing.",
        time: "09:42 AM",
        isSender: true,
      ),
    ]);
  }
}