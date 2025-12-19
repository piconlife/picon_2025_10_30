import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

/// Main CommentInputField Widget
class CommentInputField extends StatefulWidget {
  final Function(String text)? onSendText;
  final Function(File image)? onSendImage;
  final Function(File voice)? onSendVoice;
  final Function(String emoji)? onSendEmoji;
  final Function(String gif)? onSendGif;
  final String? hintText;

  const CommentInputField({
    Key? key,
    this.onSendText,
    this.onSendImage,
    this.onSendVoice,
    this.onSendEmoji,
    this.onSendGif,
    this.hintText = 'Write a comment...',
  }) : super(key: key);

  @override
  State<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();

  bool _isRecording = false;
  bool _isPaused = false;
  bool _showEmojiPicker = false;
  bool _showGifPicker = false;
  bool _showAnimatedEmojiPicker = false;
  bool _showMenuOptions = false;
  bool _showGallery = false;
  bool _hasText = false;

  // Voice recording state
  Duration _recordingDuration = Duration.zero;
  Timer? _recordingTimer;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _hasText = _textController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _isPaused = false;
      _recordingDuration = Duration.zero;
    });

    _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _recordingDuration += Duration(seconds: 1);
        });
      }
    });
  }

  void _pauseRecording() {
    setState(() {
      _isPaused = true;
    });
  }

  void _resumeRecording() {
    setState(() {
      _isPaused = false;
    });
  }

  void _stopRecording() {
    _recordingTimer?.cancel();
    setState(() {
      _isRecording = false;
      _isPaused = false;
      _recordingDuration = Duration.zero;
    });
    // TODO: Implement actual voice recording logic
    // widget.onSendVoice?.call(recordedFile);
  }

  void _cancelRecording() {
    _recordingTimer?.cancel();
    setState(() {
      _isRecording = false;
      _isPaused = false;
      _recordingDuration = Duration.zero;
    });
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      widget.onSendText?.call(_textController.text);
      _textController.clear();
    }
  }

  void _pickImageFromGallery(int index) async {
    if (index == 0) {
      // Camera
      final XFile? photo = await _imagePicker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        widget.onSendImage?.call(File(photo.path));
        setState(() {
          _showGallery = false;
        });
      }
    } else {
      // Gallery
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        widget.onSendImage?.call(File(image.path));
        setState(() {
          _showGallery = false;
        });
      }
    }
  }

  void _closeAllBottomSheets() {
    setState(() {
      _showEmojiPicker = false;
      _showGifPicker = false;
      _showAnimatedEmojiPicker = false;
      _showMenuOptions = false;
      _showGallery = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Voice Recording Widget (appears on top when recording)
          if (_isRecording) _buildVoiceRecordingWidget(),

          // Main Input Field
          _buildMainInputField(),

          // Gallery Widget (appears when camera button is clicked)
          if (_showGallery) _buildGalleryWidget(),

          // Menu Options Widget (appears when menu button is clicked)
          if (_showMenuOptions) _buildMenuOptionsWidget(),

          // Horizontal Divider
          if (_showEmojiPicker || _showGifPicker || _showAnimatedEmojiPicker)
            Divider(height: 1, thickness: 1, color: Colors.grey[300]),

          // Bottom Sheets (Emoji, GIF, Animated Emoji)
          if (_showEmojiPicker) _buildEmojiPicker(),
          if (_showGifPicker) _buildGifPicker(),
          if (_showAnimatedEmojiPicker) _buildAnimatedEmojiPicker(),
        ],
      ),
    );
  }

  Widget _buildVoiceRecordingWidget() {
    String formattedDuration =
        '${_recordingDuration.inMinutes.toString().padLeft(2, '0')}:${(_recordingDuration.inSeconds % 60).toString().padLeft(2, '0')}';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          // Recording indicator
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),

          // Duration
          Text(
            formattedDuration,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),

          SizedBox(width: 16),

          // Waveform visualization (placeholder)
          Expanded(
            child: Container(
              height: 40,
              child: CustomPaint(
                painter: WaveformPainter(isPaused: _isPaused),
              ),
            ),
          ),

          SizedBox(width: 12),

          // Control buttons
          Row(
            children: [
              // Cancel button
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: _cancelRecording,
                tooltip: 'Cancel',
              ),

              // Play/Pause button
              IconButton(
                icon: Icon(
                  _isPaused ? Icons.play_arrow : Icons.pause,
                  color: Colors.blue,
                ),
                onPressed: _isPaused ? _resumeRecording : _pauseRecording,
                tooltip: _isPaused ? 'Resume' : 'Pause',
              ),

              // Stop/Send button
              IconButton(
                icon: Icon(Icons.check_circle, color: Colors.green),
                onPressed: _stopRecording,
                tooltip: 'Send',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainInputField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Menu button (left side)
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.grey[700]),
            onPressed: () {
              setState(() {
                if (_showMenuOptions) {
                  _showMenuOptions = false;
                } else {
                  _closeAllBottomSheets();
                  _showMenuOptions = true;
                }
              });
            },
          ),

          // Text input field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  SizedBox(width: 12),

                  // Emoji button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_showEmojiPicker) {
                          _showEmojiPicker = false;
                        } else {
                          _closeAllBottomSheets();
                          _showEmojiPicker = true;
                        }
                      });
                    },
                    child: Icon(
                      _showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                  ),

                  SizedBox(width: 8),

                  // Text field
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      onTap: () {
                        _closeAllBottomSheets();
                      },
                    ),
                  ),

                  // Camera button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_showGallery) {
                          _showGallery = false;
                        } else {
                          _closeAllBottomSheets();
                          _showGallery = true;
                        }
                      });
                    },
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                  ),

                  SizedBox(width: 12),
                ],
              ),
            ),
          ),

          SizedBox(width: 8),

          // Send/Voice button (right side)
          _hasText
              ? IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: _sendMessage,
          )
              : IconButton(
            icon: Icon(Icons.mic, color: Colors.grey[700]),
            onPressed: _startRecording,
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryWidget() {
    return Container(
      height: 300,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gallery',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _showGallery = false;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 10, // Camera + 9 placeholder images
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Camera button
                  return GestureDetector(
                    onTap: () => _pickImageFromGallery(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 40, color: Colors.grey[700]),
                          SizedBox(height: 4),
                          Text(
                            'Camera',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Gallery images (placeholder)
                  return GestureDetector(
                    onTap: () => _pickImageFromGallery(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://picsum.photos/200/200?random=$index',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOptionsWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'More Options',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _showMenuOptions = false;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildMenuOption(
                icon: Icons.gif_box,
                label: 'GIF',
                onTap: () {
                  setState(() {
                    _showMenuOptions = false;
                    _closeAllBottomSheets();
                    _showGifPicker = true;
                  });
                },
              ),
              _buildMenuOption(
                icon: Icons.sentiment_satisfied_alt,
                label: 'Animated\nEmoji',
                onTap: () {
                  setState(() {
                    _showMenuOptions = false;
                    _closeAllBottomSheets();
                    _showAnimatedEmojiPicker = true;
                  });
                },
              ),
              _buildMenuOption(
                icon: Icons.attach_file,
                label: 'File',
                onTap: () {
                  // Implement file picker
                  print('File picker');
                },
              ),
              _buildMenuOption(
                icon: Icons.location_on,
                label: 'Location',
                onTap: () {
                  // Implement location picker
                  print('Location picker');
                },
              ),
              _buildMenuOption(
                icon: Icons.contact_page,
                label: 'Contact',
                onTap: () {
                  // Implement contact picker
                  print('Contact picker');
                },
              ),
              _buildMenuOption(
                icon: Icons.poll,
                label: 'Poll',
                onTap: () {
                  // Implement poll creator
                  print('Poll creator');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue, size: 28),
          ),
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiPicker() {
    List<String> emojis = [
      '😀', '😃', '😄', '😁', '😆', '😅', '🤣', '😂', '🙂', '🙃',
      '😉', '😊', '😇', '🥰', '😍', '🤩', '😘', '😗', '😚', '😙',
      '🥲', '😋', '😛', '😜', '🤪', '😝', '🤑', '🤗', '🤭', '🤫',
      '🤔', '🤐', '🤨', '😐', '😑', '😶', '😏', '😒', '🙄', '😬',
      '🤥', '😌', '😔', '😪', '🤤', '😴', '😷', '🤒', '🤕', '🤢',
      '🤮', '🤧', '🥵', '🥶', '🥴', '😵', '🤯', '🤠', '🥳', '🥸',
      '😎', '🤓', '🧐', '😕', '😟', '🙁', '☹️', '😮', '😯', '😲',
      '😳', '🥺', '😦', '😧', '😨', '😰', '😥', '😢', '😭', '😱',
    ];

    return Container(
      height: 250,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          // Emoji categories (optional tabs)
          Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('😊', style: TextStyle(fontSize: 24)),
                Text('🐶', style: TextStyle(fontSize: 24)),
                Text('🍔', style: TextStyle(fontSize: 24)),
                Text('⚽', style: TextStyle(fontSize: 24)),
                Text('🚗', style: TextStyle(fontSize: 24)),
                Text('💡', style: TextStyle(fontSize: 24)),
                Text('❤️', style: TextStyle(fontSize: 24)),
              ],
            ),
          ),
          Divider(height: 1),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: emojis.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _textController.text += emojis[index];
                    widget.onSendEmoji?.call(emojis[index]);
                  },
                  child: Center(
                    child: Text(
                      emojis[index],
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGifPicker() {
    // Placeholder GIF URLs (you would typically fetch these from an API like Giphy)
    List<String> gifs = List.generate(
      20,
          (index) => 'https://picsum.photos/200/200?random=${index + 100}',
    );

    return Container(
      height: 300,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search GIFs',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.5,
              ),
              itemCount: gifs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    widget.onSendGif?.call(gifs[index]);
                    setState(() {
                      _showGifPicker = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(gifs[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.gif_box,
                        size: 40,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedEmojiPicker() {
    // Animated emoji examples (these would be animated in a real implementation)
    List<String> animatedEmojis = [
      '🎉', '🎊', '🎈', '🎁', '🏆', '⭐', '✨', '💫',
      '🔥', '💥', '💢', '💦', '💨', '💫', '🌟', '✨',
      '❤️', '💕', '💖', '💗', '💓', '💞', '💝', '💘',
      '👏', '👍', '👎', '✌️', '🤞', '🤟', '🤘', '👌',
    ];

    return Container(
      height: 250,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Animated Emojis',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: animatedEmojis.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    widget.onSendEmoji?.call(animatedEmojis[index]);
                    setState(() {
                      _showAnimatedEmojiPicker = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        animatedEmojis[index],
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for waveform visualization
class WaveformPainter extends CustomPainter {
  final bool isPaused;

  WaveformPainter({required this.isPaused});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isPaused ? Colors.grey : Colors.red
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final barCount = 30;
    final barWidth = size.width / barCount;

    for (int i = 0; i < barCount; i++) {
      final height = (i % 3 == 0 ? 0.8 : (i % 2 == 0 ? 0.5 : 0.3)) * size.height / 2;
      final x = i * barWidth + barWidth / 2;

      canvas.drawLine(
        Offset(x, centerY - height),
        Offset(x, centerY + height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}