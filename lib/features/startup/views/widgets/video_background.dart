import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class InAppVideoBackground extends StatefulWidget {
  final String data;
  final double volume;
  final bool enabled;
  final ImageFilter? filter;
  final Widget child;

  const InAppVideoBackground({
    super.key,
    required this.data,
    this.enabled = true,
    this.volume = 0,
    this.filter,
    required this.child,
  });

  @override
  State<InAppVideoBackground> createState() => _InAppVideoBackgroundState();
}

class _InAppVideoBackgroundState extends State<InAppVideoBackground> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  void _init() {
    if (!widget.enabled) return;
    _controller = VideoPlayerController.asset(widget.data)
      ..setVolume(widget.volume)
      ..setLooping(true)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _isInitialized = true);
        _controller?.play();
      });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(InAppVideoBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data ||
        oldWidget.volume != widget.volume ||
        oldWidget.enabled != widget.enabled) {
      _controller?.dispose();
      _isInitialized = false;
      _init();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || _controller == null) return widget.child;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_isInitialized)
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          )
        else
          ColoredBox(color: Colors.black),
        if (widget.filter != null)
          BackdropFilter(filter: widget.filter!, child: SizedBox.expand()),
        widget.child,
      ],
    );
  }
}
