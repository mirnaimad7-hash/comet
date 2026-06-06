import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:comet/stories/story_model.dart';
import 'package:comet/stories/story_controller.dart';
import 'package:get/get.dart';

class StoryViewer extends StatefulWidget {
  final List<StoryItem> stories;
  final bool isMe;

  const StoryViewer({super.key, required this.stories, this.isMe = true});

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer>
    with SingleTickerProviderStateMixin {
  final StoryController storyController = Get.find<StoryController>();
  late PageController _pageController;
  VideoPlayerController? _videoController;
  late AnimationController _animController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(vsync: this);
    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) _nextStory();
    });
    _loadStory(index: 0);
  }

  void _loadStory({int index = 0}) async {
    _animController.stop();
    _animController.reset();
    _videoController?.dispose();
    _videoController = null;

    if (index < 0 || index >= storyController.myStories.length) return;

    final story = storyController.myStories[index];
    if (story.isVideo && story.file != null) {
      _videoController = VideoPlayerController.file(story.file!)
        ..initialize().then((_) {
          if (!mounted) return;
          setState(() {});
          _videoController!.play();
          _animController.duration = _videoController!.value.duration;
          _animController.forward();
        });
    } else {
      setState(() {});
      _animController.duration = const Duration(seconds: 5);
      _animController.forward();
    }
  }

  void _nextStory() {
    if (_currentIndex < storyController.myStories.length - 1) {
      _currentIndex++;
      _pageController.jumpToPage(_currentIndex);
      _loadStory(index: _currentIndex);
    } else {
      Navigator.pop(context);
    }
  }

  void _deleteCurrentStory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("حذف الستوري؟", textAlign: TextAlign.right),
        content: const Text(
          "هل تريد حذف هذه اللقطة نهائياً؟",
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _animController.forward();
              _videoController?.play();
              Navigator.pop(context);
            },
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              int indexToDelete = _currentIndex;

              if (storyController.myStories.length == 1) {
                storyController.removeStoryAt(indexToDelete);
                Navigator.pop(context);
              } else {
                if (_currentIndex == storyController.myStories.length - 1) {
                  _currentIndex--;
                  _pageController.jumpToPage(_currentIndex);
                  storyController.removeStoryAt(indexToDelete);
                  _loadStory(index: _currentIndex);
                } else {
                  storyController.removeStoryAt(indexToDelete);
                  _loadStory(index: _currentIndex);
                }
              }
            },
            child: const Text("حذف", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSeenBy() {
    _animController.stop();
    _videoController?.pause();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 400,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "شوهد بواسطة",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
                  ),
                  title: Text("مستخدم $index"),
                ),
              ),
            ),
          ],
        ),
      ),
    ).then((_) {
      _animController.forward();
      _videoController?.play();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _videoController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (storyController.myStories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return GestureDetector(
          onLongPressStart: (_) {
            _animController.stop();
            _videoController?.pause();
          },
          onLongPressEnd: (_) {
            _animController.forward();
            _videoController?.play();
          },
          onTapDown: (details) {
            final width = MediaQuery.of(context).size.width;
            if (details.globalPosition.dx < width / 3 && _currentIndex > 0) {
              _currentIndex--;
              _pageController.jumpToPage(_currentIndex);
              _loadStory(index: _currentIndex);
            } else if (details.globalPosition.dx > width * 2 / 3) {
              _nextStory();
            }
          },
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: storyController.myStories.length,
                itemBuilder: (context, index) {
                  final story = storyController.myStories[index];
                  return Center(
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: story.file == null
                                ? Container(color: Colors.blueGrey)
                                : (story.isVideo && _videoController != null
                                      ? FittedBox(
                                          fit: BoxFit.contain,
                                          child: SizedBox(
                                            width: _videoController!
                                                .value
                                                .size
                                                .width,
                                            height: _videoController!
                                                .value
                                                .size
                                                .height,
                                            child: VideoPlayer(
                                              _videoController!,
                                            ),
                                          ),
                                        )
                                      : Image.file(
                                          story.file!,
                                          fit: BoxFit.contain,
                                        )),
                          ),
                          if (story.text != null && story.text!.isNotEmpty)
                            Positioned(
                              left: story.normalizedOffset?.dx ?? 100,
                              top: story.normalizedOffset?.dy ?? 100,
                              child: FractionalTranslation(
                                translation: const Offset(-0.5, -0.5),
                                child: Text(
                                  story.text!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Row(
                        children: List.generate(
                          storyController.myStories.length,
                          (index) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: AnimatedBuilder(
                                animation: _animController,
                                builder: (context, child) =>
                                    LinearProgressIndicator(
                                      value: index == _currentIndex
                                          ? _animController.value
                                          : (index < _currentIndex ? 1.0 : 0.0),
                                      backgroundColor: Colors.white24,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                      minHeight: 2,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          if (widget.isMe)
                            PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_horiz,
                                color: Colors.white,
                                size: 32,
                              ),
                              onOpened: () {
                                _animController.stop();
                                _videoController?.pause();
                              },
                              onCanceled: () {
                                _animController.forward();
                                _videoController?.play();
                              },
                              onSelected: (val) {
                                if (val == 'del') _deleteCurrentStory();
                              },
                              itemBuilder: (ctx) => [
                                const PopupMenuItem(
                                  value: 'del',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "حذف",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
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

              if (widget.isMe)
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _showSeenBy,
                    child: Column(
                      children: [
                        const Icon(
                          Icons.keyboard_arrow_up,
                          color: Colors.white70,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          // تعديل بسيط لمعيار الألوان الحديث بدلاً من .withOpacity المستغنى عنه لتجنب التحذيرات
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.31),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "124 المشاهدات",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
