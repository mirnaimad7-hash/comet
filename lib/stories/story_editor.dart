import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StoryEditor extends StatefulWidget {
  final File? file;
  final bool isVideo;
  const StoryEditor({super.key, this.file, required this.isVideo});

  @override
  State<StoryEditor> createState() => _StoryEditorState();
}

class _StoryEditorState extends State<StoryEditor> {
  final TextEditingController _textController = TextEditingController();
  VideoPlayerController? _videoController;
  Offset _textOffset = const Offset(150, 300); 
  bool _showTextField = false;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo && widget.file != null) {
      _videoController = VideoPlayerController.file(widget.file!)..initialize().then((_) => setState(() {}));
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.text_fields, color: Colors.white), onPressed: () => setState(() => _showTextField = !_showTextField)),
          TextButton(
            onPressed: () {
             
              Navigator.pop(context, {
                'file': widget.file,
                'text': _textController.text,
                'isVideo': widget.isVideo,
                'normalizedOffset': Offset(_textOffset.dx, _textOffset.dy), // نرسل القيمة الخام للتجربة
              });
            },
            child: const Text("Share", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ],
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16, 
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                color: Colors.grey[900],
                child: Stack(
                  children: [
                  
                    Positioned.fill(
                      child: widget.file == null 
                        ? Container(color: Colors.blueGrey) 
                        : (widget.isVideo 
                            ? VideoPlayer(_videoController!) 
                            : Image.file(widget.file!, fit: BoxFit.contain)),
                    ),
                  
                    if (_showTextField)
                      Positioned(
                        left: _textOffset.dx,
                        top: _textOffset.dy,
                        child: GestureDetector(
                        onPanUpdate: (details) {
  setState(() {
    _textOffset = Offset(
  
      (_textOffset.dx + details.delta.dx).clamp(0, constraints.maxWidth),
      (_textOffset.dy + details.delta.dy).clamp(0, constraints.maxHeight),
    );
  });
},
                          child: FractionalTranslation(
                            translation: const Offset(-0.5, -0.5),
                            child: IntrinsicWidth(
                              child: TextField(
                                controller: _textController,
                                autofocus: true,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 10, color: Colors.black)]),
                                decoration: const InputDecoration(border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}