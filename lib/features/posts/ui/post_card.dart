import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/post_model.dart';
import 'post_controller.dart';
import '../../profile/profile_controller.dart';
import 'post_details_page.dart';
import 'package:comet/features/posts/ui/comments_sheet.dart';

class PostCard extends StatelessWidget {
  final int index;
  final PostModel post;

  const PostCard({super.key, required this.index, required this.post});

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find<PostController>();

    final ProfileController profileController = Get.put(ProfileController());

    bool isMyPost =
        post.userName == profileController.displayName.value ||
        post.userName == 'Alexia Rivera';

    return InkWell(
      onTap: () {
        Get.to(
          () => PostDetailsPage(
            userName: isMyPost
                ? profileController.displayName.value
                : post.userName,
            text: post.text,
            allMedia: post.allMedia,
            img: isMyPost ? profileController.avatarPath.value : post.img,
            index: index,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              bool dynamicIsMyPost =
                  post.userName == profileController.displayName.value ||
                  post.userName == 'Alexia Rivera';

              String currentImage = dynamicIsMyPost
                  ? profileController.avatarPath.value
                  : post.userImage;
              String currentName = dynamicIsMyPost
                  ? profileController.displayName.value
                  : post.userName;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      currentImage.startsWith('http') || currentImage.isEmpty
                      ? (currentImage.isEmpty
                            ? const AssetImage(
                                    'assets/images/default_avatar.png',
                                  )
                                  as ImageProvider
                            : NetworkImage(currentImage) as ImageProvider)
                      : FileImage(File(currentImage)),
                ),
                title: Text(
                  currentName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(post.time),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    postController.deletePost(index);
                    Get.snackbar(
                      'تم الحذف',
                      'تم إزالة المنشور بنجاح',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.withValues(alpha: 0.8),
                      colorText: Colors.white,
                    );
                  },
                ),
              );
            }),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(post.text, style: const TextStyle(fontSize: 16)),
            ),

            if (post.allMedia.isNotEmpty)
              SizedBox(
                height: 200,
                width: double.infinity,
                child:
                    post.allMedia.first.path.toLowerCase().endsWith('.mp4') ||
                        post.allMedia.first.path.toLowerCase().endsWith('.mov')
                    ? Container(
                        color: Colors.black,
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Image.file(
                        post.allMedia.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
              )
            else if (post.img.isNotEmpty)
              Obx(() {
                bool dynamicIsMyPost =
                    post.userName == profileController.displayName.value ||
                    post.userName == 'Alexia Rivera';
                String currentImg = dynamicIsMyPost
                    ? profileController.avatarPath.value
                    : post.img;

                return currentImg.startsWith('http') || currentImg.isEmpty
                    ? Image.network(
                        post.img,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      )
                    : Image.file(
                        File(currentImg),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      );
              }),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(() {
                  final currentPost = postController.posts[index];
                  return IconButton(
                    icon: Icon(
                      currentPost.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: currentPost.isLiked ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => postController.toggleLike(index),
                  );
                }),
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  onPressed: () {
                    Get.bottomSheet(
                      CommentsSheet(
                        userName: isMyPost
                            ? profileController.displayName.value
                            : post.userName,
                        text: post.text,
                        index: index,
                      ),
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      ignoreSafeArea: false,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
