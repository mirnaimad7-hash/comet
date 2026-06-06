import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:comet/stories/story_model.dart';

class StoryController extends GetxController {
  var myStories = <StoryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStories();
  }

  Future<void> loadStories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String>? savedData = prefs.getStringList('comet_stories');

      if (savedData != null) {
        List<StoryItem> loaded = savedData.map((item) {
          return StoryItem.fromJson(jsonDecode(item));
        }).toList();

        loaded.removeWhere(
          (story) => DateTime.now().difference(story.createdAt).inHours >= 24,
        );

        myStories.assignAll(loaded);
        saveStories();
      }
    } catch (e) {
      print("Error loading stories: $e");
    }
  }

  Future<void> saveStories() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> dataToSave = myStories
        .map((story) => jsonEncode(story.toJson()))
        .toList();
    await prefs.setStringList('comet_stories', dataToSave);
  }

  void addStory(StoryItem story) {
    myStories.add(story);
    saveStories();
  }

  void removeStoryAt(int index) {
    if (index >= 0 && index < myStories.length) {
      myStories.removeAt(index);
      saveStories();
    }
  }
}
