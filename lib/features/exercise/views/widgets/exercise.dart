import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

import '../../../../data/entities/exercise.dart';
import '../../../../roots/widgets/directionality.dart';

extension MapExtension<T extends Object?> on Map<double, T> {
  T? _find(double value, List<double> points, int start, int end) {
    if (start > end) return null;
    int mid = (start + end) ~/ 2;
    double point = points[mid];
    if (value < point) return _find(value, points, start, mid - 1);
    if (mid == points.length - 1 || value < points[mid + 1]) return this[point];
    return _find(value, points, mid + 1, end);
  }

  T? where(double selection) {
    return _find(selection, keys.toList()..sort(), 0, values.length - 1);
  }
}

enum ExerciseStatus { exercise, rest }

class ExercisePlayerController extends ChangeNotifier {
  // Core controllers
  AnimationController? _animationController;
  VideoPlayerController? _videoController;
  Timer? _remainingTicker;
  Timer? _restTimer;

  ExercisePlayerController([TickerProvider? vsync]) {
    if (vsync != null) {
      _animationController = AnimationController(vsync: vsync);
    }
  }

  // Variables
  Duration _totalDuration = Duration.zero;

  // State variables
  final _initialized = ValueNotifier(false);
  final _isPlaying = ValueNotifier(false);
  final _isFinished = ValueNotifier(false);
  final _isResting = ValueNotifier(false);
  final _isVideoLoading = ValueNotifier(false);
  final _currentIndex = ValueNotifier(0);
  final _currentRepeatCount = ValueNotifier(0);
  final _progress = ValueNotifier(0.0);
  final _remainingRestTime = ValueNotifier(Duration.zero);
  final _totalRemainingDuration = ValueNotifier(Duration.zero);
  final _feedback = ValueNotifier(0);
  List<String> _labels = [];

  // Data
  List<Exercise> _exercises = [];
  ValueChanged<ExerciseStatus>? _onStart;
  ValueChanged<ExerciseStatus>? _onComplete;
  VoidCallback? _onFinish;

  // Getters
  double get animationValue => _animationController?.value ?? 0;

  List<Exercise> get exercises => _exercises;

  Duration get totalDuration => _totalDuration;

  // STATES
  ValueNotifier<bool> get initialized => _initialized;

  ValueNotifier<bool> get isPlaying => _isPlaying;

  ValueNotifier<bool> get isFinished => _isFinished;

  ValueNotifier<bool> get isResting => _isResting;

  ValueNotifier<bool> get isVideoLoading => _isVideoLoading;

  ValueNotifier<int> get currentIndex => _currentIndex;

  ValueNotifier<int> get currentRepeatCount => _currentRepeatCount;

  ValueNotifier<double> get progress => _progress;

  ValueNotifier<Duration> get remainingRestTime => _remainingRestTime;

  ValueNotifier<Duration> get totalRemainingDuration => _totalRemainingDuration;

  AnimationController? get animationController => _animationController;

  VideoPlayerController? get videoController => _videoController;

  Exercise get currentExercise {
    return _exercises.elementAtOrNull(_currentIndex.value) ?? Exercise.empty();
  }

  int get maxRepeatCount => currentExercise.repetitions;

  ValueNotifier<int> get feedback => _feedback;

  List<String> get labels => _labels;

  void _updateFeedback() {
    final value = currentExercise.feedbacks.where(
      _animationController?.value ?? 0,
    );
    if (_feedback.value != value) {
      _feedback.value = value ?? 0;
    }
  }

  void _calculateTotalDuration() {
    final x = exercises;
    if (x.isEmpty) {
      _totalDuration = Duration.zero;
    }
    final secs = x.fold(0, (a, b) => a + b.totalDurationInSec);
    _totalDuration = Duration(seconds: secs);
    _totalRemainingDuration.value = Duration(seconds: secs);
  }

  // Initialization
  Future<void> initialize({
    required List<Exercise> exercises,
    ValueChanged<ExerciseStatus>? onStart,
    ValueChanged<ExerciseStatus>? onComplete,
    VoidCallback? onFinish,
    Map<String, String> localizations = const {"rest": "Rest"},
  }) async {
    _exercises = exercises;
    _onStart = onStart;
    _onComplete = onComplete;
    _onFinish = onFinish;
    _labels = _exercises
        .expand((e) => [e.name, localizations['rest'] ?? "Rest"])
        .take(_exercises.length * 2 - 1)
        .toList();

    _calculateTotalDuration();
    _setupAnimationController();
    await _initializeVideoController();
    _initialized.value = true;
    notifyListeners();
  }

  void _setupAnimationController() {
    _animationController?.addStatusListener(_onAnimationStatusChanged);
    _animationController?.addListener(_onAnimationListen);
  }

  void _onAnimationListen() {
    if (_exercises.isNotEmpty &&
        _currentIndex.value < _exercises.length &&
        _exercises[_currentIndex.value].type == ExerciseType.lottie) {
      _updateProgress(
        (_currentRepeatCount.value + animationValue) / maxRepeatCount,
      );
      _updateFeedback();
    }
  }

  // Video handling
  Future<void> _initializeVideoController() async {
    if (!_isValidIndex() || currentExercise.type != ExerciseType.video) {
      return;
    }
    _isVideoLoading.value = true;
    try {
      await _videoController?.dispose();
      _videoController = VideoPlayerController.asset(currentExercise.preview);
      await _videoController!.initialize();
      _videoController!.addListener(_onVideoProgressChanged);
      _isVideoLoading.value = false;
    } catch (e) {
      _isVideoLoading.value = false;
      debugPrint('Error initializing video: $e');
    }
  }

  void _onVideoProgressChanged() {
    if (_videoController?.value.isInitialized != true) return;

    final position = _videoController!.value.position;
    final duration = _videoController!.value.duration;

    if (duration.inMilliseconds > 0) {
      _updateProgress(
        (_currentRepeatCount.value +
                (position.inMilliseconds / duration.inMilliseconds)) /
            maxRepeatCount,
      );

      // Check if video completed
      if (position >= duration && _isPlaying.value) {
        _onMediaCompleted();
      }
    }
  }

  // Animation handling
  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _onMediaCompleted();
    }
  }

  void _onReady(LottieComposition composition) {
    _animationController?.duration = currentExercise.duration;
  }

  void _onMediaCompleted() {
    _currentRepeatCount.value++;

    if (_currentRepeatCount.value < maxRepeatCount) {
      _repeatCurrentExercise();
    } else {
      _completeCurrentExercise();
    }
  }

  void _repeatCurrentExercise() {
    if (currentExercise.type == ExerciseType.lottie) {
      _animationController?.reset();
      _animationController?.forward();
    } else {
      _videoController?.seekTo(Duration.zero);
      _videoController?.play();
    }
  }

  void _completeCurrentExercise() {
    _isPlaying.value = false;
    _onComplete?.call(ExerciseStatus.exercise);
    _moveToNext();
  }

  void _moveToNext() {
    if (_currentIndex.value < _exercises.length - 1) {
      _startRestPeriod();
    } else {
      _completeAllExercises();
    }
  }

  void _completeAllExercises() {
    _isFinished.value = true;
    _onFinish?.call();
  }

  // Rest period handling
  void _startRestPeriod() {
    final restDuration = _exercises[_currentIndex.value].restTime;
    _isResting.value = true;
    _remainingRestTime.value = restDuration;
    _onStart?.call(ExerciseStatus.rest);
    _restTimer?.cancel();
    _restTimer = Timer.periodic(
      const Duration(milliseconds: 50),
      (_) => _updateRestProgress(restDuration),
    );
  }

  void _updateRestProgress(Duration totalRest) {
    _remainingRestTime.value = Duration(
      milliseconds: (_remainingRestTime.value.inMilliseconds - 50)
          .clamp(0, double.infinity)
          .toInt(),
    );

    final elapsed = totalRest - _remainingRestTime.value;
    _updateProgress(elapsed.inMicroseconds / totalRest.inMicroseconds);

    if (_remainingRestTime.value.inMilliseconds <= 0) {
      _completeRestPeriod();
    }
  }

  void _completeRestPeriod() {
    _restTimer?.cancel();
    _isResting.value = false;
    _currentIndex.value++;
    _currentRepeatCount.value = 0;
    _remainingRestTime.value = Duration.zero;
    _updateProgress(0.0);

    _onComplete?.call(ExerciseStatus.rest);

    if (_isValidIndex()) {
      _startNextExercise();
    }

    notifyListeners();
  }

  void _startNextExercise() {
    const delay = Duration(milliseconds: 300);
    if (currentExercise.type == ExerciseType.lottie) {
      _animationController?.reset();
      Future.delayed(delay, () {
        if (_isValidIndex()) {
          _animationController?.forward();
          _onStart?.call(ExerciseStatus.exercise);
          _setPlaying(true);
        }
      });
    } else {
      _initializeVideoController().then((_) {
        if (_videoController != null) {
          _videoController!.play();
          _onStart?.call(ExerciseStatus.exercise);
          _setPlaying(true);
        }
      });
    }
  }

  // Public controls
  void play() {
    if (_exercises.isEmpty || _isResting.value) return;

    if (_isFinished.value) {
      reset();
      Future.delayed(const Duration(milliseconds: 300), _startCurrentMedia);
      return;
    }

    if (!_isValidIndex()) return;
    _startCurrentMedia();
  }

  void pause() {
    if (currentExercise.type == ExerciseType.lottie) {
      _animationController?.stop();
    } else {
      _videoController?.pause();
    }
    _setPlaying(false);
  }

  void togglePlayPause() => _isPlaying.value ? pause() : play();

  void reset() {
    _restTimer?.cancel();
    _animationController?.reset();
    _videoController?.dispose();
    _videoController = null;

    _currentIndex.value = 0;
    _currentRepeatCount.value = 0;
    _isFinished.value = false;
    _isPlaying.value = false;
    _isResting.value = false;
    _isVideoLoading.value = false;
    _progress.value = 0.0;
    _remainingRestTime.value = Duration.zero;

    notifyListeners();
  }

  void skipRest() {
    if (_isResting.value) {
      _restTimer?.cancel();
      _updateRemainingTime(_remainingRestTime.value);
      _completeRestPeriod();
    }
  }

  void goToExercise(int index) {
    if (index < 0 || index >= _exercises.length) return;

    _restTimer?.cancel();
    _animationController?.reset();
    _currentIndex.value = index;
    _currentRepeatCount.value = 0;
    _isResting.value = false;
    _setPlaying(false);
    _updateProgress(0.0);
  }

  void seekToProgress(double progress) {
    _updateProgress(progress.clamp(0.0, 1.0));
    if (currentExercise.type == ExerciseType.lottie) {
      _animationController?.animateTo(_progress.value);
    } else if (_videoController?.value.isInitialized == true) {
      final position = Duration(
        milliseconds:
            (_progress.value * currentExercise.duration.inMilliseconds).round(),
      );
      _videoController!.seekTo(position);
    }
  }

  // Helper methods
  void _startCurrentMedia() {
    if (!_isValidIndex()) return;

    if (currentExercise.type == ExerciseType.lottie) {
      _animationController?.forward();
      _setPlaying(true);
    } else {
      if (_videoController?.value.isInitialized != true) {
        _initializeVideoController().then((_) {
          _videoController?.play();
          _setPlaying(true);
        });
      } else {
        _videoController!.play();
        _setPlaying(true);
      }
    }
  }

  void _updateRemainingTime(Duration value) {
    _totalRemainingDuration.value = _totalRemainingDuration.value - value;
  }

  void _setRemainingTimer(bool playing) {
    if (!playing) {
      return _remainingTicker?.cancel();
    }
    _remainingTicker?.cancel();
    _remainingTicker = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateRemainingTime(Duration(seconds: 1));
    });
  }

  void _setPlaying(bool playing) {
    _isPlaying.value = playing;
    _setRemainingTimer(playing);
  }

  void _updateProgress(double progress) {
    _progress.value = progress.clamp(0.0, 1.0);
  }

  bool _isValidIndex() {
    return _currentIndex.value >= 0 && _currentIndex.value < _exercises.length;
  }

  @override
  void dispose() {
    _initialized.dispose();
    _isPlaying.dispose();
    _isFinished.dispose();
    _isResting.dispose();
    _isVideoLoading.dispose();
    _currentIndex.dispose();
    _currentRepeatCount.dispose();
    _progress.dispose();
    _totalRemainingDuration.dispose();
    _remainingRestTime.dispose();
    _feedback.dispose();
    _restTimer?.cancel();
    _remainingTicker?.cancel();
    _animationController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }
}

class ExercisePlayer extends StatefulWidget {
  final ExercisePlayerController controller;
  final Widget? restWidget;
  final Widget? errorWidget;
  final Widget? notFoundWidget;
  final Widget? completedWidget;
  final Widget? loadingWidget;

  const ExercisePlayer({
    super.key,
    required this.controller,
    this.restWidget,
    this.errorWidget,
    this.notFoundWidget,
    this.completedWidget,
    this.loadingWidget,
  });

  @override
  State<ExercisePlayer> createState() => _ExercisePlayerState();
}

class _ExercisePlayerState extends State<ExercisePlayer> {
  late final ExercisePlayerController _controller = widget.controller;

  void _update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller.initialized.addListener(_update);
    _controller.isResting.addListener(_update);
    _controller.isFinished.addListener(_update);
    _controller.isVideoLoading.addListener(_update);
    _controller.videoController?.addListener(_update);
  }

  @override
  void dispose() {
    _controller.initialized.removeListener(_update);
    _controller.isResting.removeListener(_update);
    _controller.isFinished.removeListener(_update);
    _controller.isVideoLoading.removeListener(_update);
    _controller.videoController?.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.exercises.isEmpty) {
      return widget.notFoundWidget ?? const SizedBox.shrink();
    }

    if (_controller.isResting.value) {
      return widget.restWidget ?? const SizedBox.shrink();
    }

    if (_controller.isFinished.value) {
      return widget.completedWidget ?? const SizedBox.shrink();
    }

    return InAppDirectionality(isForce: true, child: _buildExerciseWidget());
  }

  Widget _buildExerciseWidget() {
    final exercise = _controller.currentExercise;
    final index = _controller.currentIndex;
    switch (exercise.type) {
      case ExerciseType.lottie:
        return Lottie.asset(
          key: ValueKey('lottie_$index'),
          controller: _controller.animationController,
          exercise.preview,
          onLoaded: _controller._onReady,
        );

      case ExerciseType.video:
        if (_controller.isVideoLoading.value) {
          return widget.loadingWidget ?? const SizedBox.shrink();
        }

        final videoController = _controller.videoController;
        if (videoController?.value.isInitialized == true) {
          return AspectRatio(
            key: ValueKey('video_$index'),
            aspectRatio: videoController!.value.aspectRatio,
            child: VideoPlayer(videoController),
          );
        }

        return widget.loadingWidget ?? const SizedBox.shrink();

      default:
        return SizedBox();
    }
  }
}
