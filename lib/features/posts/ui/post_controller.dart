import 'package:get/get.dart';
import 'dart:io';
import '../logic/post_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../profile/profile_controller.dart';

class PostController extends GetxController {
  var selectedIndex = 0.obs;

  var posts = <PostModel>[
    PostModel(
      userName: "Alexander Ray",
      userImage:
          "https://images.unsplash.com/photo-1464802686167-b939a6910659?w=500",
      time: "2 hours ago",
      text: "Exploring the cosmos tonight! 🌌",
      img: "https://images.unsplash.com/photo-1464802686167-b939a6910659?w=500",
      allMedia: [],
      comments: ["ما شاء الله، شغل بطل 🔥", "بالتوفيق يا معلم"],
    ),
    PostModel(
      userName: "Luna Sterling",
      userImage:
          "https://images.unsplash.com/photo-1497215728101-856f4ea42174?w=500",
      time: "Just now",
      text: "Minimalist vibes only. 🪴",
      img: "https://images.unsplash.com/photo-1497215728101-856f4ea42174?w=500",
      allMedia: [],
      comments: ["جميلة جداً!"],
    ),
  ].obs;
  @override
  void onInit() {
    super.onInit();
    loadPostsFromPrefs();
  }

  void changePage(int index) {
    selectedIndex.value = index;
  }

  void addNewPost(String content, List<File> media) {
    final ProfileController profileController = Get.find<ProfileController>();

    String currentUserName = profileController.displayName.value;
    String currentUserImage = profileController.avatarPath.value;

    final newPost = PostModel(
      userName: currentUserName,
      userImage: currentUserImage,
      time: "Just now",
      text: content,
      img: currentUserImage,
      allMedia: media,
      comments: [],
    );

    posts.insert(0, newPost);
    savePostsToPrefs();
  }

  void toggleLike(int index) {
    posts[index].isLiked = !posts[index].isLiked;
    posts.refresh();
    savePostsToPrefs();
  }

  void addComment(int index, String commentText) {
    if (commentText.trim().isNotEmpty) {
      posts[index].comments.add(commentText);
      posts.refresh();
      savePostsToPrefs();
    }
  }

  void deletePost(int index) {
    posts.removeAt(index);
    savePostsToPrefs();
  }

  Future<void> savePostsToPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> jsonList = posts
        .map((post) => post.toJson())
        .toList();

    String encodedData = jsonEncode(jsonList);

    await prefs.setString('saved_comet_posts', encodedData);
  }

  Future<void> loadPostsFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('saved_comet_posts');

    if (encodedData != null) {
      List<dynamic> decodedList = jsonDecode(encodedData);

      posts.assignAll(
        decodedList.map((postJson) => PostModel.fromJson(postJson)).toList(),
      );
    }
  }
}
