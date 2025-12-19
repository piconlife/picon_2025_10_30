import 'dart:io';

import 'package:flutter/material.dart';

import 'field.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comment Input Field Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: CommentInputDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CommentInputDemo extends StatefulWidget {
  @override
  State<CommentInputDemo> createState() => _CommentInputDemoState();
}

class _CommentInputDemoState extends State<CommentInputDemo> {
  final List<Comment> _comments = [];

  void _addComment(String text, {String? type, String? data}) {
    setState(() {
      _comments.insert(
        0,
        Comment(
          text: text,
          type: type ?? 'text',
          data: data,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comment Input Field Demo'), elevation: 2),
      body: Column(
        children: [
          // Comments list
          Expanded(
            child:
                _comments.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No comments yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Be the first to comment!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.all(16),
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        return _buildCommentItem(_comments[index]);
                      },
                    ),
          ),

          // Comment input field
          CommentInputField(
            hintText: 'Write a comment...',
            onSendText: (text) {
              _addComment(text);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Text sent: $text'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            onSendImage: (image) {
              _addComment('Image sent', type: 'image', data: image.path);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Image sent: ${image.path}'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            onSendVoice: (voice) {
              _addComment('Voice message', type: 'voice', data: voice.path);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Voice sent: ${voice.path}'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            onSendEmoji: (emoji) {
              print('Emoji selected: $emoji');
            },
            onSendGif: (gif) {
              _addComment('GIF sent', type: 'gif', data: gif);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('GIF sent'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: Text('U', style: TextStyle(color: Colors.white)),
          ),
          SizedBox(width: 12),

          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username and timestamp
                Row(
                  children: [
                    Text(
                      'User',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      _formatTimestamp(comment.timestamp),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 4),

                // Comment content based on type
                _buildCommentContent(comment),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentContent(Comment comment) {
    switch (comment.type) {
      case 'text':
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(comment.text),
        );

      case 'image':
        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                comment.data != null
                    ? Image.file(File(comment.data!), fit: BoxFit.cover)
                    : Center(
                      child: Icon(Icons.image, size: 48, color: Colors.grey),
                    ),
          ),
        );

      case 'voice':
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.mic, color: Colors.blue),
              SizedBox(width: 8),
              Text('Voice message', style: TextStyle(color: Colors.blue)),
              SizedBox(width: 8),
              Icon(Icons.play_arrow, color: Colors.blue),
            ],
          ),
        );

      case 'gif':
        return Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                comment.data != null
                    ? Image.network(comment.data!, fit: BoxFit.cover)
                    : Center(
                      child: Icon(Icons.gif_box, size: 48, color: Colors.grey),
                    ),
          ),
        );

      default:
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(comment.text),
        );
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class Comment {
  final String text;
  final String type;
  final String? data;
  final DateTime timestamp;

  Comment({
    required this.text,
    required this.type,
    this.data,
    required this.timestamp,
  });
}
