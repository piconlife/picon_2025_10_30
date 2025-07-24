import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';

import '../../../../app/res/icons.dart';
import '../../../../roots/utils/utils.dart';
import '../../../../roots/widgets/align.dart';
import '../../../../roots/widgets/directionality.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/multi_listenable_builder.dart';
import '../../../../roots/widgets/text.dart';
import '../widgets/countdown_text.dart';
import '../widgets/exercise.dart';

const kExerciseLandscapeControlsVisibilityDuration =
    "exercise_landscape_controls_visibility_duration";

class ExerciseLandscapeMode extends StatefulWidget {
  final ExercisePlayerController controller;
  final TabController labelController;
  final ValueNotifier<bool> isHapticEnabled;
  final ValueNotifier<bool> isSpeechEnabled;
  final VoidCallback? onClose;
  final VoidCallback? toggleHaptic;
  final VoidCallback? toggleSpeech;

  const ExerciseLandscapeMode({
    super.key,
    required this.controller,
    required this.labelController,
    required this.isHapticEnabled,
    required this.isSpeechEnabled,
    required this.onClose,
    required this.toggleHaptic,
    required this.toggleSpeech,
  });

  @override
  State<ExerciseLandscapeMode> createState() => _ExerciseLandscapeModeState();
}

class _ExerciseLandscapeModeState extends State<ExerciseLandscapeMode>
    with ColorMixin, TranslationMixin {
  late final _controller = widget.controller;

  String get status =>
      localizes(
        "statuses",
        defaultValue: ["Squeeze", "Hold", "Relax"],
      ).elementAtOrNull(_controller.feedback.value) ??
      localize("default_status", defaultValue: "Squeeze");

  @override
  String get name => "exercise:main";

  @override
  void initState() {
    super.initState();
    Utils.hideStatusBar();
    Utils.setOrientation(Orientation.landscape);
  }

  @override
  void dispose() {
    super.dispose();
    Utils.showStatusBar();
    Utils.resetOrientation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: InAppLayout(
        layout: LayoutType.row,
        children: [
          Expanded(
            flex: 2,
            child: InAppLayout(
              layout: LayoutType.stack,
              fit: StackFit.expand,
              children: [
                Center(child: _buildPreview()),
                InAppAlign(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildStatus(),
                  ),
                ),
                InAppAlign(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: _buildName(),
                  ),
                ),
                InAppDirectionality(
                  child: ValueListenableBuilder(
                    valueListenable: _controller.progress,
                    builder: (context, progress, child) {
                      return LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.transparent,
                        color: secondary.t10,
                      );
                    },
                  ),
                ),
                InAppAlign(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildBackButton(),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(),
          Expanded(child: _buildControls()),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      color: light,
      child: InAppLayout(
        layout: LayoutType.stack,
        fit: StackFit.expand,
        children: [
          Center(child: _buildPlayPauseButton()),
          Align(alignment: Alignment.bottomCenter, child: _buildButtons()),
        ],
      ),
    );
  }

  void _question() {}

  Widget _buildBackButton() {
    return InAppGesture(
      onTap: widget.onClose,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: dark.t05, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: InAppIcon(InAppIcons.close.regular, color: dark),
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return MultiListenableBuilder(
      listenables: [_controller.isResting, _controller.isPlaying],
      builder: (context, child) {
        return InAppGesture(
          onTap: _controller.isResting.value
              ? _controller.skipRest
              : _controller.togglePlayPause,
          child: InAppIcon(
            _controller.isResting.value
                ? Icons.skip_next_rounded
                : _controller.isPlaying.value
                ? "assets/icons/ic_animation_pause.svg"
                : "assets/icons/ic_animation_play.svg",
            color: secondary,
            size: 54,
          ),
        );
      },
    );
  }

  Widget _buildStatus() {
    return MultiListenableBuilder(
      listenables: [
        _controller.currentIndex,
        _controller.isResting,
        _controller.feedback,
      ],
      builder: (context, child) {
        if (_controller.currentExercise.type.isVideo) return SizedBox();
        return InAppText(
          _controller.isResting.value
              ? localize("relax_for", defaultValue: "Relax for")
              : localize(status, defaultValue: status),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: dark,
            fontWeight: FontWeight.w800,
            fontSize: 36,
          ),
        );
      },
    );
  }

  Widget _buildName() {
    return ListenableBuilder(
      listenable: _controller.currentIndex,
      builder: (context, child) {
        return InAppText(
          localize(
            _controller.currentExercise.name,
            defaultValue: _controller.currentExercise.nameOrNull ?? "Unknown",
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: dark,
            fontWeight: FontWeight.w800,
            fontSize: 28,
          ),
        );
      },
    );
  }

  Widget _buildPreview() {
    return ExercisePlayer(controller: _controller, restWidget: _buildRest());
  }

  Widget _buildRest() {
    return CountdownText(
      data: List.generate(5, (index) => "${index + 1}").reversed.toList(),
      textStyle: TextStyle(
        color: dark,
        fontWeight: FontWeight.w700,
        fontSize: 100,
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: InAppLayout(
        layout: LayoutType.row,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
            valueListenable: widget.isSpeechEnabled,
            builder: (context, isSpeechEnabled, child) {
              return InAppGesture(
                onTap: widget.toggleSpeech,
                child: InAppIcon(
                  Icons.volume_up_outlined,
                  color: isSpeechEnabled ? dark : dark.t25,
                  size: 28,
                ),
              );
            },
          ),
          SizedBox(width: 32),
          ValueListenableBuilder(
            valueListenable: widget.isHapticEnabled,
            builder: (context, isHapticEnabled, child) {
              return InAppGesture(
                onTap: widget.toggleHaptic,
                child: InAppIcon(
                  Icons.vibration,
                  color: isHapticEnabled ? dark : dark.t25,
                  size: 28,
                ),
              );
            },
          ),
          SizedBox(width: 32),
          InAppGesture(
            onTap: _question,
            child: InAppIcon(
              "assets/icons/ic_question_solid.svg",
              color: dark,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
