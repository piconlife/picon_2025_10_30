import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class InAppLottieController extends ChangeNotifier {
  AnimationController? _animationController;

  double _zoomLevel = 1.0;
  bool _isPlaying = false;
  bool _isCompleted = false;
  int _currentRepeatCount = 0;
  double _progress = 0.0;
  Duration _totalDuration = Duration.zero;
  int _maxRepeatCount = 5;
  VoidCallback? _onComplete;

  // Getters
  double get zoomLevel => _zoomLevel;

  bool get isPlaying => _isPlaying;

  bool get isCompleted => _isCompleted;

  int get currentRepeatCount => _currentRepeatCount;

  double get progress => _progress;

  Duration get totalDuration => _totalDuration;

  int get maxRepeatCount => _maxRepeatCount;

  /// Initialize the controller with AnimationController
  void _initialize(
    AnimationController animationController, {
    int repeatCount = 5,
    VoidCallback? onComplete,
    double initialZoom = 1.0,
  }) {
    _animationController = animationController;
    _maxRepeatCount = repeatCount;
    _onComplete = onComplete;
    _zoomLevel = initialZoom;

    // Listen to animation status changes
    _animationController!.addStatusListener(_onAnimationStatusChanged);

    // Listen to animation value changes for progress
    _animationController!.addListener(() {
      _progress = _animationController!.value;
      notifyListeners();
    });
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _currentRepeatCount++;

      if (_currentRepeatCount < _maxRepeatCount) {
        // Reset and play again
        _animationController!.reset();
        _animationController!.forward();
      } else {
        // Animation completed all repeats
        _isPlaying = false;
        _isCompleted = true;
        notifyListeners();

        // Call onComplete callback
        _onComplete?.call();
      }
    }
  }

  /// Set total duration when animation loads
  void _setTotalDuration(Duration duration) {
    _totalDuration = duration;
    notifyListeners();
  }

  /// Play the animation
  void play() {
    if (_animationController == null) return;

    if (_isCompleted) {
      reset();
    }

    _animationController!.forward();
    _isPlaying = true;
    notifyListeners();
  }

  /// Pause the animation
  void pause() {
    if (_animationController == null) return;

    _animationController!.stop();
    _isPlaying = false;
    notifyListeners();
  }

  /// Toggle play/pause
  void togglePlayPause() {
    if (_isPlaying) {
      pause();
    } else {
      play();
    }
  }

  /// Reset the animation to beginning
  void reset() {
    if (_animationController == null) return;

    _animationController!.reset();
    _currentRepeatCount = 0;
    _isCompleted = false;
    _isPlaying = false;
    _progress = 0.0;
    notifyListeners();
  }

  /// Stop the animation
  void stop() {
    if (_animationController == null) return;

    _animationController!.stop();
    _isPlaying = false;
    notifyListeners();
  }

  /// Seek to specific progress (0.0 to 1.0)
  void seekToProgress(double progress) {
    if (_animationController == null) return;

    _progress = progress.clamp(0.0, 1.0);
    _animationController!.animateTo(_progress);
    notifyListeners();
  }

  /// Seek to specific time
  void seekToTime(Duration time) {
    if (_totalDuration.inMilliseconds == 0) return;

    final progress = time.inMilliseconds / _totalDuration.inMilliseconds;
    seekToProgress(progress.clamp(0.0, 1.0));
  }

  /// Zoom in
  void zoomIn([double step = 0.2]) {
    _zoomLevel = (_zoomLevel + step).clamp(0.1, 5.0);
    notifyListeners();
  }

  /// Zoom out
  void zoomOut([double step = 0.2]) {
    _zoomLevel = (_zoomLevel - step).clamp(0.1, 5.0);
    notifyListeners();
  }

  /// Set zoom level directly
  void setZoom(double zoom) {
    _zoomLevel = zoom.clamp(0.1, 5.0);
    notifyListeners();
  }

  /// Reset zoom to 1.0
  void resetZoom() {
    _zoomLevel = 1.0;
    notifyListeners();
  }

  /// Set repeat count
  void setRepeatCount(int count) {
    _maxRepeatCount = count.clamp(1, 100);
    notifyListeners();
  }

  /// Set custom duration
  void setDuration(Duration duration) {
    if (_animationController == null) return;

    _animationController!.duration = duration;
    notifyListeners();
  }

  /// Get current time position
  Duration get currentTime {
    return Duration(
      milliseconds: (_progress * _totalDuration.inMilliseconds).round(),
    );
  }

  /// Get formatted current time
  String get formattedCurrentTime => _formatDuration(currentTime);

  /// Get formatted total duration
  String get formattedTotalDuration => _formatDuration(_totalDuration);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }
}

class InAppLottie extends StatefulWidget {
  final String data;
  final InAppLottieController controller;
  final VoidCallback? onComplete;
  final double initialZoom;
  final Duration? duration;
  final int repeatCount;

  const InAppLottie({
    super.key,
    required this.data,
    required this.controller,
    this.onComplete,
    this.initialZoom = 1.0,
    this.duration,
    this.repeatCount = 5,
  });

  @override
  State<InAppLottie> createState() => _InAppLottieState();
}

class _InAppLottieState extends State<InAppLottie>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(seconds: 2),
    );

    widget.controller._initialize(
      _animationController,
      repeatCount: widget.repeatCount,
      onComplete: widget.onComplete,
      initialZoom: widget.initialZoom,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.controller.zoomLevel,
          child: Lottie.asset(
            widget.data,
            controller: _animationController,
            onLoaded: (composition) {
              widget.controller._setTotalDuration(composition.duration);
              if (widget.duration != null) {
                _animationController.duration = widget.duration;
              } else {
                _animationController.duration = composition.duration;
              }
            },
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}
