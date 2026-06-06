import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:comet/stories/story_model.dart';
import 'package:comet/stories/story_editor.dart';
import 'package:comet/stories/story_viewer.dart';
import 'package:comet/stories/story_controller.dart';
import 'package:get/get.dart';

class StoriesSection extends StatefulWidget {
  const StoriesSection({super.key});

  @override
  State<StoriesSection> createState() => _StoriesSectionState();
}

class _StoriesSectionState extends State<StoriesSection> {
  final ImagePicker _picker = ImagePicker();
  final StoryController storyController = Get.put(StoryController());

  Future<void> _openEditor(File? file, bool isVideo) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryEditor(file: file, isVideo: isVideo),
      ),
    );

    if (result != null && mounted) {
      storyController.addStory(
        StoryItem(
          file: result['file'],
          text: result['text'],
          isVideo: result['isVideo'],
          normalizedOffset: result['normalizedOffset'],
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text("صورة"),
            onTap: () => _pickMedia(isVideo: false),
          ),
          ListTile(
            leading: const Icon(Icons.videocam),
            title: const Text("فيديو"),
            onTap: () => _pickMedia(isVideo: true),
          ),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text("نص فقط"),
            onTap: () => _addTextStory(),
          ),
        ],
      ),
    );
  }

  Future<void> _pickMedia({required bool isVideo}) async {
    Navigator.pop(context);
    final XFile? media = isVideo
        ? await _picker.pickVideo(source: ImageSource.gallery)
        : await _picker.pickImage(source: ImageSource.gallery);
    if (media != null) _openEditor(File(media.path), isVideo);
  }

  void _addTextStory() {
    Navigator.pop(context);
    _openEditor(null, false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Obx(
        () => ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            _buildAddCircle(),
            if (storyController.myStories.isNotEmpty) _buildViewCircle(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCircle() {
    return GestureDetector(
      onTap: _showPickerOptions,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey,
              child: Icon(Icons.add, color: Colors.white, size: 30),
            ),
            SizedBox(height: 5),
            Text("Add", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildViewCircle() {
    final lastStory = storyController.myStories.last;
    Widget previewImage;

    if (lastStory.file != null && !lastStory.isVideo) {
      previewImage = Image.file(lastStory.file!, fit: BoxFit.cover);
    } else if (lastStory.isVideo && lastStory.file != null) {
      previewImage = Container(
        color: Colors.black87,
        child: const Center(
          child: Icon(Icons.play_arrow, color: Colors.white, size: 24),
        ),
      );
    } else {
      previewImage = Container(
        color: const Color(0xFF6B46C0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              lastStory.text ?? "",
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StoryViewer(stories: storyController.myStories, isMe: true),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    Colors.purple,
                    Colors.orange,
                    Colors.pink,
                    Colors.purple,
                  ],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: SizedBox(width: 56, height: 56, child: previewImage),
                ),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "قصصك",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
