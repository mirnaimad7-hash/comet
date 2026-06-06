import 'package:flutter/material.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'comments_sheet.dart';

class PostDetailsPage extends StatefulWidget {
  final String userName;
  final String text;
  final List<File>? allMedia;
  final String img;
  final int initialPage;
  final int index;
  const PostDetailsPage({
    super.key,
    required this.userName,
    required this.text,
    this.allMedia,
    required this.img,
    this.initialPage = 0,
    required this.index,
  });

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  late PageController _pageController;

  final List<dynamic> _combinedMedia = [];

  @override
  void initState() {
    super.initState();

    if (widget.allMedia != null && widget.allMedia!.isNotEmpty) {
      _combinedMedia.addAll(widget.allMedia!);
    }

    if (widget.img.isNotEmpty) {
      _combinedMedia.add(widget.img);
    }

    _pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.userName,
          style: const TextStyle(color: Colors.white),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.comment_outlined, color: Colors.white),
            onPressed: () {
              Get.bottomSheet(
                CommentsSheet(
                  userName: widget.userName,
                  text: widget.text,
                  index: widget.index,
                ),
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _combinedMedia.isEmpty
                ? const Center(
                    child: Text(
                      "لا توجد ميديا لعرضها",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : PageView.builder(
                    controller: _pageController,
                    itemCount: _combinedMedia.length,
                    itemBuilder: (context, index) {
                      final mediaItem = _combinedMedia[index];

                      if (mediaItem is File) {
                        return _MediaViewer(file: mediaItem);
                      } else if (mediaItem is String) {
                        return InteractiveViewer(
                          panEnabled: true,
                          minScale: 1.0,
                          maxScale: 4.0,
                          child: Center(
                            child: Image.network(
                              mediaItem,
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                    size: 50,
                                  ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
          ),

          if (widget.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              width: double.infinity,
              // ممرر الـ maxHeight بطريقة صحيحة عبر الـ constraints ✅
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MediaViewer extends StatefulWidget {
  final File file;
  const _MediaViewer({required this.file});

  @override
  State<_MediaViewer> createState() => _MediaViewerState();
}

class _MediaViewerState extends State<_MediaViewer> {
  VideoPlayerController? _controller;
  bool _isVideo = false;
  bool _showPlayIcon = false;

  @override
  void initState() {
    super.initState();
    _isVideo =
        widget.file.path.toLowerCase().endsWith('.mp4') ||
        widget.file.path.toLowerCase().endsWith('.mov');

    if (_isVideo) {
      _controller = VideoPlayerController.file(widget.file)
        ..initialize().then((_) {
          setState(() {});
          _controller!.play();
          _controller!.setLooping(true);
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller != null && _controller!.value.isInitialized) {
      setState(() {
        if (_controller!.value.isPlaying) {
          _controller!.pause();
          _showPlayIcon = true;
        } else {
          _controller!.play();
          _showPlayIcon = false;
        }
      });

      if (!_showPlayIcon) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) setState(() => _showPlayIcon = false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isVideo) {
      return GestureDetector(
        onTap: _togglePlay,
        child: _controller != null && _controller!.value.isInitialized
            ? Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                    if (!_controller!.value.isPlaying || _showPlayIcon)
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _controller!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
      );
    } else {
      return InteractiveViewer(
        panEnabled: true,
        minScale: 1.0,
        maxScale: 5.0,
        child: Center(child: Image.file(widget.file, fit: BoxFit.contain)),
      );
    }
  }
}
