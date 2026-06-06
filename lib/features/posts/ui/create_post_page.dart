import 'dart:io';
import 'package:comet/features/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:comet/features/posts/ui/post_controller.dart';

class CreatePostPage extends StatefulWidget {
  final VoidCallback? onBackTap;
  final Function(Map<String, dynamic>)? onPostCreated;

  const CreatePostPage({super.key, this.onBackTap, this.onPostCreated});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  bool isTimeCapsuleEnabled = true;
  final List<File> _allMedia = [];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _postController = TextEditingController();
  String _privacyStatus = 'PUBLIC';
  IconData _privacyIcon = Icons.public;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  String _selectedEmoji = "";
  String _selectedText = "Feeling / Activity";

  final List<Map<String, String>> _feelingsList = [
    {'name': 'السعادة', 'emoji': '😇'},
    {'name': 'المحبة', 'emoji': '🥰'},
    {'name': 'الحزن', 'emoji': '😟'},
    {'name': 'الحماسة', 'emoji': '🤩'},
    {'name': 'الجنون', 'emoji': '🤪'},
    {'name': 'البهجة', 'emoji': '😊'},
    {'name': 'الهدوء', 'emoji': '😌'},
    {'name': 'الاسترخاء', 'emoji': '😴'},
  ];

  final List<Map<String, String>> _activitiesList = [
    {'name': 'أشاهد...', 'emoji': '👓'},
    {'name': 'أحتفل بـ...', 'emoji': '🎉'},
    {'name': 'أتناول...', 'emoji': '🍩'},
    {'name': 'أستمع إلى...', 'emoji': '🎧'},
    {'name': 'أسافر إلى...', 'emoji': '✈️'},
    {'name': 'ألعب...', 'emoji': '🎮'},
  ];

  Future<void> _pickMedia(bool isVideo) async {
    if (isVideo) {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) setState(() => _allMedia.add(File(video.path)));
    } else {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() => _allMedia.addAll(images.map((img) => File(img.path))));
      }
    }
  }

  void _showFeelingActivityPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DefaultTabController(
        length: 2,
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const TabBar(
                labelColor: Color(0xFF6B46C0),
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color(0xFF6B46C0),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(text: "المشـاعر"),
                  Tab(text: "النشـاطات"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildEmojiGrid(_feelingsList),
                    _buildEmojiGrid(_activitiesList),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiGrid(List<Map<String, String>> dataList) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: dataList.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          setState(() {
            _selectedEmoji = dataList[index]['emoji']!;
            _selectedText = dataList[index]['name']!;
          });
          Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dataList[index]['emoji']!,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Text(
                dataList[index]['name']!,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _showPrivacyPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Who can see your post?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            _buildPrivacyOption('PUBLIC', Icons.public),
            _buildPrivacyOption('FRIENDS', Icons.people),
            _buildPrivacyOption('ONLY ME', Icons.lock),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6B46C0)),
      title: Text(title),
      onTap: () {
        setState(() {
          _privacyStatus = title;
          _privacyIcon = icon;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.7),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF6B46C0)),
          onPressed: () {
            if (widget.onBackTap != null) {
              widget.onBackTap!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Create Post',
          style: TextStyle(
            color: Color(0xFF0B1C30),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B46C0), Color(0xFF8E5EFF)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (_postController.text.isNotEmpty || _allMedia.isNotEmpty) {
                    final PostController postController =
                        Get.find<PostController>();

                    postController.addNewPost(_postController.text, _allMedia);

                    postController.changePage(0);
                    Get.back();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'POST NOW',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserHeader(profileController),
            TextField(
              controller: _postController,
              maxLines: null,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 250,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF4FF),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: _allMedia.isEmpty
                          ? const Center(
                              child: Icon(
                                Icons.grid_view,
                                color: Colors.grey,
                                size: 40,
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.all(4),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 4,
                                    mainAxisSpacing: 4,
                                  ),
                              itemCount: _allMedia.length,
                              itemBuilder: (context, index) {
                                String path = _allMedia[index].path
                                    .toLowerCase();
                                bool isVideo =
                                    path.endsWith('.mp4') ||
                                    path.endsWith('.mov');
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullScreenPreview(
                                        allMedia: _allMedia,
                                        initialIndex: index,
                                        onDelete: (idx) => setState(
                                          () => _allMedia.removeAt(idx),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        isVideo
                                            ? Container(
                                                color: Colors.black87,
                                                child: const Icon(
                                                  Icons.play_circle_fill,
                                                  color: Colors.white70,
                                                  size: 30,
                                                ),
                                              )
                                            : Image.file(
                                                _allMedia[index],
                                                fit: BoxFit.cover,
                                              ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: _buildMediaSquare(
                            Icons.videocam,
                            () => _pickMedia(true),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickMedia(false),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: const DecorationImage(
                                  image: NetworkImage(
                                    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=400',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildFeelingButton(),
            const SizedBox(height: 12),
            _buildActionTile(
              Icons.location_on,
              'Add Location',
              const Color(0xFF00D2FD),
              trailing: 'NEAR YOU',
            ),
            const SizedBox(height: 24),

            _buildTimeCapsule(),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'COMET',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF6B46C0).withOpacity(0.05),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeelingButton() {
    return GestureDetector(
      onTap: _showFeelingActivityPicker,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            _selectedEmoji.isEmpty
                ? const Icon(Icons.mood, color: Color(0xFF6B46C0))
                : Text(_selectedEmoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 16),
            Text(
              _selectedText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (_selectedEmoji.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                onPressed: () => setState(() {
                  _selectedEmoji = "";
                  _selectedText = "Feeling / Activity";
                }),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(ProfileController profileController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),

      child: Obx(() {
        String currentImage = profileController.avatarPath.value;
        String currentName = profileController.displayName.value;

        return Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[200],
              backgroundImage:
                  currentImage.startsWith('http') || currentImage.isEmpty
                  ? (currentImage.isEmpty
                        ? const AssetImage('assets/images/default_avatar.png')
                              as ImageProvider
                        : NetworkImage(currentImage) as ImageProvider)
                  : FileImage(File(currentImage)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: _showPrivacyPicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _privacyIcon,
                          size: 14,
                          color: const Color(0xFF532AA7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _privacyStatus,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(Icons.expand_more, size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMediaSquare(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFEFF4FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: Colors.grey[400], size: 28),
      ),
    );
  }

  Widget _buildActionTile(
    IconData icon,
    String title,
    Color color, {
    String? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          if (trailing != null)
            Text(
              trailing,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeCapsule() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF6B46C0).withOpacity(0.05), Colors.white],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF6B46C0).withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.auto_awesome, color: Color(0xFF6B46C0)),
                  SizedBox(width: 8),
                  Text(
                    'Time Capsule',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              Switch(
                value: isTimeCapsuleEnabled,
                onChanged: (v) => setState(() => isTimeCapsuleEnabled = v),
                activeThumbColor: const Color(0xFF6B46C0),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildCapsuleInput(
                'RELEASE DATE',
                DateFormat('MMM dd, yyyy').format(_selectedDate),
                Icons.calendar_month,
                _selectDate,
              ),
              const SizedBox(width: 12),
              _buildCapsuleInput(
                'LOCAL TIME',
                _selectedTime.format(context),
                Icons.access_time,
                _selectTime,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCapsuleInput(
    String label,
    String value,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(icon, size: 16, color: const Color(0xFF6B46C0)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FullScreenPreview extends StatefulWidget {
  final List<File> allMedia;
  final int initialIndex;
  final Function(int) onDelete;

  const FullScreenPreview({
    super.key,
    required this.allMedia,
    required this.initialIndex,
    required this.onDelete,
  });
  @override
  State<FullScreenPreview> createState() => _FullScreenPreviewState();
}

class _FullScreenPreviewState extends State<FullScreenPreview> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("تأكيد الحذف", textAlign: TextAlign.right),
        content: const Text(
          "هل أنت متأكد من حذف هذا الشيء من المنشور؟",
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(
              context,
            ), // إغلاق الديالوج فقط والبقاء في المعاينة
            child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              widget.onDelete(_currentIndex);

              Navigator.pop(context);

              Navigator.pop(context);
            },
            child: const Text(
              "حذف",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 28,
            ),
            onPressed: _confirmDelete,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.allMedia.length,
        onPageChanged: (i) => _currentIndex = i,
        itemBuilder: (context, index) {
          File file = widget.allMedia[index];
          bool isVideo = file.path.toLowerCase().endsWith('.mp4');
          file.path.toLowerCase().endsWith('.mov');
          return isVideo
              ? VideoPreviewItem(file: file, key: ValueKey(file.path))
              : InteractiveViewer(
                  child: Center(child: Image.file(file, fit: BoxFit.contain)),
                );
        },
      ),
    );
  }
}

class VideoPreviewItem extends StatefulWidget {
  final File file;
  const VideoPreviewItem({super.key, required this.file});

  @override
  State<VideoPreviewItem> createState() => _VideoPreviewItemState();
}

class _VideoPreviewItemState extends State<VideoPreviewItem> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _controller.setLooping(true);
            _controller.play();
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? GestureDetector(
            onTap: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  if (!_controller.value.isPlaying)
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.black45,
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                ],
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator(color: Colors.white));
  }
}
