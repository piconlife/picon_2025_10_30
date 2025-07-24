import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';

import '../../../../app/res/icons.dart';
import '../../../../roots/widgets/align.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/multi_listenable_builder.dart';
import '../../../../roots/widgets/text.dart';
import '../widgets/countdown_text.dart';
import '../widgets/exercise.dart';
import '../widgets/linear_progress.dart';

class ExercisePortraitMode extends StatefulWidget {
  final ExercisePlayerController controller;
  final TabController labelController;
  final ValueNotifier<bool> isHapticEnabled;
  final ValueNotifier<bool> isSpeechEnabled;
  final VoidCallback? onClose;
  final VoidCallback? toggleHaptic;
  final VoidCallback? toggleSpeech;

  const ExercisePortraitMode({
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
  State<ExercisePortraitMode> createState() => _ExercisePortraitModeState();
}

class _ExercisePortraitModeState extends State<ExercisePortraitMode>
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: InAppLayout(
        layout: LayoutType.stack,
        children: [
          _buildPreview(),
          _buildTitle(),
          _buildStatuses(),
          _buildControls(),
          _buildAppbar(),
        ],
      ),
    );
  }

  void _question() {}

  Widget _buildAppbar() {
    return InAppAlign(
      alignment: Alignment(0, -0.9),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: kToolbarHeight,
          child: InAppLayout(
            layout: LayoutType.stack,
            alignment: Alignment.centerLeft,
            children: [
              Center(
                child: ValueListenableBuilder(
                  valueListenable: _controller.totalRemainingDuration,
                  builder: (context, duration, child) {
                    return InAppText(
                      localize(
                        "time_left",
                        defaultValue: '{MINUTE} min left',
                        applyNumber: true,
                        replace: (value) {
                          return value.replaceAll(
                            "{MINUTE}",
                            "${duration.inMinutes}",
                          );
                        },
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ),
              InAppGesture(
                onTap: widget.onClose,
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: dark.t05, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(11),
                  alignment: Alignment.center,
                  child: InAppIcon(
                    InAppIcons.arrowBack.regular,
                    color: dark,
                    flipByTextDirection: true,
                  ),
                ),
              ),
              InAppAlign(
                alignment: Alignment.centerRight,
                child: InAppGesture(
                  onTap: _question,
                  child: InAppIcon(
                    "assets/icons/ic_question_solid.svg",
                    color: dark.t95,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Align(
      alignment: Alignment(0, -0.64),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: MultiListenableBuilder(
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
                  : status,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: dark,
                fontWeight: FontWeight.w800,
                fontSize: 36,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return InAppAlign(
      alignment: Alignment.center,
      child: ExercisePlayer(controller: _controller, restWidget: _buildRest()),
    );
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

  Widget _buildStatuses() {
    return InAppAlign(
      alignment: Alignment(0, 0.56),
      child: SizedBox(
        height: kToolbarHeight * 1.1,
        child: Theme(
          data: ThemeData(
            useMaterial3: false,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          child: Directionality(
            textDirection: textDirection,
            child: IgnorePointer(
              child: ListenableBuilder(
                listenable: _controller.initialized,
                builder: (context, child) {
                  return ListenableBuilder(
                    listenable: widget.labelController,
                    builder: (context, child) {
                      return TabBar(
                        controller: widget.labelController,
                        isScrollable: true,
                        mouseCursor: MouseCursor.uncontrolled,
                        physics: NeverScrollableScrollPhysics(),
                        labelPadding: EdgeInsets.symmetric(horizontal: 24),
                        tabAlignment: TabAlignment.center,
                        dividerColor: Colors.transparent,
                        enableFeedback: false,
                        dividerHeight: 0,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorPadding: EdgeInsets.zero,
                        indicatorColor: Colors.transparent,
                        tabs: List.generate(widget.labelController.length, (
                          index,
                        ) {
                          final label = _controller.labels[index];
                          final selected =
                              widget.labelController.index == index;
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            alignment: selected
                                ? Alignment.topCenter
                                : Alignment.bottomCenter,
                            child: selected
                                ? ValueListenableBuilder(
                                    key: ValueKey("${index}_$label"),
                                    valueListenable: _controller.progress,
                                    builder: (context, progress, child) {
                                      return LinearShaderMask(
                                        textDirection: textDirection,
                                        progress: progress,
                                        progressColor: secondary,
                                        remainingColor: dark,
                                        child: child!,
                                      );
                                    },
                                    child: InAppText(
                                      localize(label, defaultValue: label),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: dark,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,
                                      ),
                                    ),
                                  )
                                : InAppText(
                                    label,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: dark.t50,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          );
                        }),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return InAppAlign(
      alignment: Alignment(0, 0.8),
      child: SizedBox(
        height: 65,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: InAppLayout(
            layout: LayoutType.stack,
            alignment: Alignment.center,
            children: [
              MultiListenableBuilder(
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
              ),
              InAppAlign(
                alignment: Alignment.centerLeft,
                child: ValueListenableBuilder(
                  valueListenable: widget.isHapticEnabled,
                  builder: (context, isHapticEnabled, child) {
                    return InAppGesture(
                      onTap: widget.toggleHaptic,
                      child: InAppIcon(
                        Icons.vibration,
                        color: isHapticEnabled ? dark : dark.t25,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
              InAppAlign(
                alignment: Alignment.centerRight,
                child: ValueListenableBuilder(
                  valueListenable: widget.isSpeechEnabled,
                  builder: (context, isSpeechEnabled, child) {
                    return InAppGesture(
                      onTap: widget.toggleSpeech,
                      child: InAppIcon(
                        Icons.volume_up_outlined,
                        color: isSpeechEnabled ? dark : dark.t25,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
