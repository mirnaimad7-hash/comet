import 'dart:io';
import 'package:flutter/material.dart';

class StoryItem {
  final File? file;
  final String? text;
  final bool isVideo;
  final Offset? normalizedOffset;
  final DateTime createdAt;

  StoryItem({
    this.file,
    this.text,
    required this.isVideo,
    this.normalizedOffset,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'filePath': file?.path ?? '',
      'text': text,
      'isVideo': isVideo,
      'offsetX': normalizedOffset?.dx,
      'offsetY': normalizedOffset?.dy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory StoryItem.fromJson(Map<String, dynamic> json) {
    final String path = json['filePath'] ?? '';
    return StoryItem(
      file: path.isNotEmpty ? File(path) : null,
      text: json['text'],
      isVideo: json['isVideo'] ?? false,
      normalizedOffset: json['offsetX'] != null && json['offsetY'] != null
          ? Offset(json['offsetX'], json['offsetY'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
