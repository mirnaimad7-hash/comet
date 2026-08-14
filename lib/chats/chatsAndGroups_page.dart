// ignore_for_file: file_names, deprecated_member_use, unnecessary_underscores

import 'dart:io';
import 'package:comet/chats/chats_page.dart';
import 'package:comet/group/create_group_page.dart';
import 'package:comet/core/theme/app_colors.dart';
import 'package:comet/group/group_chat_page.dart';
import 'package:comet/home/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsAndGroupsController extends GetxController {
  var groupsData = <LocalGroupModel>[
    LocalGroupModel(
      name: "Digital Artisans",
      desc: "Exploring the intersection of AI art and traditional canvas.",
      tag: "Admin",
      members: "1.2k members",
    ),
    LocalGroupModel(
      name: "Cyberpunk Collective",
      desc: "Futuristic aesthetics and hardware modification discussions.",
      tag: "Moderator",
      members: "856 members",
    ),
    LocalGroupModel(
      name: "The Solstice Path",
      desc: "Weekly photography challenges and outdoor meetups.",
      tag: "",
      members: "3.4k members",
    ),
  ].obs;
}

class ChatsAndGroupsPage extends StatefulWidget {
  const ChatsAndGroupsPage({super.key});

  @override
  State<ChatsAndGroupsPage> createState() => _ChatsAndGroupsPageState();
}

class _ChatsAndGroupsPageState extends State<ChatsAndGroupsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final ChatsAndGroupsController groupsController = Get.put(
    ChatsAndGroupsController(),
  );

  String _pageSubTitle = "RECENT DIALOGUES";
  String _pageTitle = "Messages";
  bool _showCreateGroupButton = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;
    setState(() {
      if (_tabController.index == 0) {
        _pageSubTitle = "RECENT DIALOGUES";
        _pageTitle = "Messages";
        _showCreateGroupButton = false;
      } else {
        _pageSubTitle = "COMMUNITY";
        _pageTitle = "Groups";
        _showCreateGroupButton = true;
      }
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            _buildBackgroundWatermark(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildHeaderSection(),
                _buildSearchBarSection(),
                _buildTabBarSection(),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [_buildDirectMessagesList(), _buildGroupsList()],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundWatermark() {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: Opacity(
        opacity: 0.07,
        child: Image.asset(
          'assets/logo.png',
          width: double.infinity,
          height: 300,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _pageSubTitle,
                  style: const TextStyle(
                    color: AppColors.secondaryNeon,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _pageTitle,
                  style: const TextStyle(
                    color: AppColors.onSurfaceColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 32,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ],
            ),
          ),
          if (_showCreateGroupButton) _buildCreateGroupButton(),
        ],
      ),
    );
  }

  Widget _buildCreateGroupButton() {
    return GestureDetector(
      onTap: () => Get.to(() => CreateGroupPage()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.secondaryNeon, AppColors.primaryNeon],
          ),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryNeon,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, color: AppColors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              "Create Group",
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBarSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.babyblue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(fontSize: 16, color: AppColors.onSurfaceColor),
          decoration: InputDecoration(
            hintText: "Search conversations...",
            hintStyle: TextStyle(
              color: AppColors.textGrey,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.search, color: AppColors.textGrey, size: 24),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0),
      child: Container(
        height: 54,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColors.babyblue,
          borderRadius: BorderRadius.circular(24),
        ),
        child: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondaryNeon.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          labelColor: AppColors.secondaryNeon,
          unselectedLabelColor: AppColors.darkblue,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Plus Jakarta Sans',
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: 'Plus Jakarta Sans',
          ),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: "Direct Messages"),
            Tab(text: "Groups"),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectMessagesList() {
    final List<LocalChatModel> chatList = [
      LocalChatModel(
        name: "Elena Vance",
        message: "The final celestial renders are ready for review!",
        time: "2M AGO",
        isUnread: true,
        unreadCount: "3",
        isOnline: true,
      ),
      LocalChatModel(
        name: "Design Orbit 🪐",
        message: "Did anyone check the new grid?",
        time: "12:45 PM",
        isGroup: true,
        groupSender: "Julian: ",
      ),
      LocalChatModel(
        name: "Marcus Chen",
        message: "See you at the gallery opening tonight.",
        time: "YESTERDAY",
      ),
      LocalChatModel(
        name: "Sarah Jenkins",
        message: "The presentation looked amazing. Great job team.",
        time: "TUE",
      ),
      LocalChatModel(
        name: "David Bloom",
        message: "Thanks for the feedback on the prototype.",
        time: "OCT 22",
        isMuted: true,
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: chatList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final chat = chatList[index];
        return GestureDetector(
          onTap: () {
            Get.to(
              () => ChatPage(
                userName: chat.name,
                userAvatar:
                    "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=80",
                isOnline: chat.isOnline,
              ),
            );
          },
          child: Opacity(
            opacity: chat.isMuted ? 0.6 : 1.0,
            child: Row(
              children: [
                _buildChatAvatar(chat, index),
                const SizedBox(width: 16),
                _buildChatDetails(chat),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatAvatar(LocalChatModel chat, int index) {
    if (chat.isGroup) {
      return SizedBox(
        width: 58,
        height: 58,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: _buildCircleAvatar(
                "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=80",
                38,
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: _buildCircleAvatar(
                "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80",
                38,
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        _buildCircleAvatar(
          "https://images.unsplash.com/photo/picture/${index + 10}",
          58,
        ),
        if (chat.isOnline)
          Positioned(
            bottom: 1,
            right: 1,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCircleAvatar(String url, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: size == 38 ? 2 : 0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
          onError: (_, __) =>
              const Icon(Icons.person, color: AppColors.textGrey),
        ),
      ),
    );
  }

  Widget _buildChatDetails(LocalChatModel chat) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                chat.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurfaceColor,
                  fontSize: 16,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
              Text(
                chat.time,
                style: TextStyle(
                  color: chat.isUnread
                      ? AppColors.secondaryNeon
                      : AppColors.textGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: const TextStyle(fontSize: 13, fontFamily: 'Inter'),
                    children: [
                      if (chat.isGroup) ...[
                        TextSpan(
                          text: chat.groupSender,
                          style: const TextStyle(
                            color: AppColors.secondaryNeon,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: chat.message,
                          style: const TextStyle(color: AppColors.darkblue),
                        ),
                      ] else ...[
                        TextSpan(
                          text: chat.message,
                          style: TextStyle(
                            color: chat.isUnread
                                ? AppColors.onSurfaceColor
                                : AppColors.darkblue,
                            fontWeight: chat.isUnread
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (chat.isUnread) _buildUnreadCounter(chat.unreadCount),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnreadCounter(String count) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      height: 22,
      width: 22,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 247, 255),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNeon.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          count,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildGroupsList() {
    return Obx(
      () => ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        itemCount: groupsController.groupsData.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final group = groupsController.groupsData[index];

          return GestureDetector(
            onTap: () {
              Get.to(() => GroupChatPage(group: group));
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondaryNeon.withOpacity(0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.babyblue,
                      borderRadius: BorderRadius.circular(16),
                      image: group.avatar.isNotEmpty
                          ? DecorationImage(
                              image: group.avatar.startsWith('http')
                                  ? NetworkImage(group.avatar) as ImageProvider
                                  : FileImage(File(group.avatar)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: group.avatar.isEmpty
                        ? const Center(
                            child: Icon(
                              Icons.blur_on,
                              color: AppColors.secondaryNeon,
                              size: 28,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                group.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurfaceColor,
                                  fontSize: 16,
                                  fontFamily: 'Plus Jakarta Sans',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (group.tag.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.gradientLightPurple
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  group.tag,
                                  style: const TextStyle(
                                    color: AppColors.secondaryNeon,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          group.desc,
                          style: const TextStyle(
                            color: AppColors.darkblue,
                            fontSize: 13,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.group_outlined,
                              size: 16,
                              color: AppColors.textGrey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              group.members,
                              style: const TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class LocalChatModel {
  final String name;
  final String message;
  final String time;
  final bool isUnread;
  final String unreadCount;
  final bool isGroup;
  final String groupSender;
  final bool isOnline;
  final bool isMuted;

  LocalChatModel({
    required this.name,
    required this.message,
    required this.time,
    this.isUnread = false,
    this.unreadCount = "0",
    this.isGroup = false,
    this.groupSender = "",
    this.isOnline = false,
    this.isMuted = false,
  });
}

class LocalGroupModel {
  final String name;
  final String desc;
  final String tag;
  final String members;
  final String avatar;

  LocalGroupModel({
    required this.name,
    required this.desc,
    this.tag = "",
    required this.members,
    this.avatar = "",
  });
}
