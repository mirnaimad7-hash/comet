import 'dart:io';

class PostModel {
  final String userName;
  final String userImage;
  final String time;
  final String text;
  final String img;
  final List<File> allMedia;
  bool isLiked;
  final List<String> comments;

  PostModel({
    required this.userName,
    required this.userImage,
    required this.time,
    required this.text,
    required this.img,
    required this.allMedia,
    this.isLiked = false,
    required this.comments,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      userName: json['userName'] ?? '',
      userImage: json['userImage'] ?? '',
      time: json['time'] ?? '',
      text: json['text'] ?? '',
      img: json['img'] ?? '',
      allMedia:
          (json['allMedia'] as List<dynamic>?)
              ?.map((path) => File(path as String))
              .toList() ??
          [],
      isLiked: json['isLiked'] ?? false,

      comments: List<String>.from(json['comments'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userImage': userImage,
      'time': time,
      'text': text,
      'allMedia': allMedia.map((file) => file.path).toList(),
      'img': img,
      'isLiked': isLiked,
      'comments': comments,
    };
  }
}
