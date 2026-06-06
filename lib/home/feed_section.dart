import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../features/posts/ui/post_controller.dart';
import '../features/posts/ui/post_card.dart';

class FeedSection extends StatelessWidget {
  const FeedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find<PostController>();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Smart Feed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.tune),
            ],
          ),
        ),

        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: postController.posts.length,
            itemBuilder: (context, index) {
              final post = postController.posts[index];
              return PostCard(index: index, post: post);
            },
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Opacity(
            opacity: 0.1,
            child: Text(
              'COMET',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
