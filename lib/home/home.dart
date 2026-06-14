import 'dart:io';
import 'package:comet/chats/chatsAndGroups_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../features/posts/ui/post_controller.dart';
import 'custom_app_bar.dart';
import '../stories/stories_section.dart';
import 'feed_section.dart';
import 'bottom_nav.dart';
import '../features/posts/ui/create_post_page.dart';
import '../search_page/search_page.dart';
import '../features/profile/profile_page.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final PostController postController = Get.put(PostController());

  Widget _getLayout(int index) {
    switch (index) {
      case 0:
        return SingleChildScrollView(
          key: const PageStorageKey('home_scroll'),
          child: Column(
            children: [
              const SizedBox(height: 10),
              StoriesSection(),
              const FeedSection(),
              const SizedBox(height: 100),
            ],
          ),
        );
      case 1:
        return const SearchPage();
      case 2:
        return const SizedBox();
      case 3:
        return const ChatsAndGroupsPage();
      case 4:
        return const ProfilePage();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (postController.selectedIndex.value != 0) {
          postController.changePage(0);
        } else {
          exit(0);
        }
      },
      child: Obx(
        () => Scaffold(
          backgroundColor: const Color(0xFFF8F9FF),
          appBar: postController.selectedIndex.value == 0
              ? const CustomAppBar()
              : null,
          body: Stack(
            children: [
              _getLayout(postController.selectedIndex.value),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CustomBottomNav(
                  currentIndex: postController.selectedIndex.value,
                  onTap: (index) {
                    if (index == 2) {
                      Get.to(() => const CreatePostPage());
                    } else {
                      postController.changePage(index);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
