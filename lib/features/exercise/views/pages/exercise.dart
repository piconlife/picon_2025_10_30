import 'dart:async';

import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/object.dart';
import 'package:flutter_andomie/utils/configs.dart';
import 'package:flutter_andomie/utils/settings.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_navigator/in_app_navigator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../data/entities/exercise.dart';
import '../../../../data/enums/shift.dart';
import '../../../../data/models/plan.dart';
import '../../../../roots/utils/haptic.dart';
import '../../../../roots/utils/speech.dart';
import '../../../../roots/utils/utils.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../routes/paths.dart';
import '../../data/cubits/daily_plan.dart';
import '../dialogs/quit.dart';
import '../templates/exercise_landscape_mode.dart';
import '../templates/exercise_portrait_mode.dart';
import '../widgets/countdown_text.dart';
import '../widgets/exercise.dart';

const kExerciseSpeechOn = "exercise_speech_on";
const kExerciseHapticOn = "exercise_haptic_on";

bool get isExerciseSpeechOn {
  return Settings.get(
    kExerciseSpeechOn,
    Configs.get(kExerciseSpeechOn, defaultValue: true),
  );
}

bool get isExerciseHapticOn {
  return Settings.get(
    kExerciseHapticOn,
    Configs.get(kExerciseHapticOn, defaultValue: true),
  );
}

class ExercisePage extends StatefulWidget {
  final bool dialogMode;
  final Object? args;

  const ExercisePage({super.key, this.dialogMode = false, this.args});

  static Future<T?>? show<T extends Object?>({
    required BuildContext context,
    Object? args,
  }) {
    return showCupertinoModalBottomSheet(
      expand: true,
      topRadius: Radius.circular(28),
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final dailyPlanCubit = args.getOrNull("$DailyPlanCubit");
        return MultiBlocProvider(
          providers: [
            dailyPlanCubit is DailyPlanCubit
                ? BlocProvider.value(value: dailyPlanCubit)
                : BlocProvider(create: (context) => DailyPlanCubit()),
          ],
          child: ExercisePage(dialogMode: true, args: args),
        );
      },
    );
  }

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage>
    with TranslationMixin, ColorMixin, TickerProviderStateMixin {
  /// --------------------------------------------------------------------------
  /// LET

  late final cubit = context.read<DailyPlanCubit>();

  late Shift shift = widget.args.findByKey("shift", defaultValue: Shift.any);

  late final _controller = ExercisePlayerController(this);

  late final _labelController = TabController(
    length: _controller.labels.length,
    vsync: this,
  );

  /// LET
  /// --------------------------------------------------------------------------
  /// VARIABLE

  bool _initialCountdown = true;

  /// VARIABLE
  /// --------------------------------------------------------------------------
  /// SPEECH

  final _isSpeechEnabled = ValueNotifier(isExerciseSpeechOn);

  void _toggleSpeech() {
    _isSpeechEnabled.value = !_isSpeechEnabled.value;
    Settings.set(kExerciseSpeechOn, _isSpeechEnabled.value);
  }

  void _speak(String text) {
    if (!_isSpeechEnabled.value) return;
    Speech.speak(text);
  }

  /// SPEECH
  /// --------------------------------------------------------------------------
  /// HAPTIC

  final _isHapticEnabled = ValueNotifier(isExerciseHapticOn);

  void _toggleHaptic() {
    _isHapticEnabled.value = !_isHapticEnabled.value;
    Settings.set(kExerciseHapticOn, _isHapticEnabled.value);
  }

  void _haptic(int level) {
    if (!_isHapticEnabled.value) return;
    switch (level) {
      case 0:
        return Haptics.soft();
      case 1:
        Haptics.light();
    }
  }

  /// HAPTIC
  /// --------------------------------------------------------------------------
  /// ORIENTATION

  void _toggleOrientation() => Utils.toggleOrientation(context);

  /// ORIENTATION
  /// --------------------------------------------------------------------------
  /// GETS

  DailyPlan get plan => cubit.state.plan;

  List<Exercise> get exercises {
    if (plan.isEmpty) {
      return widget.args.findByKey("exercises", defaultValue: []);
    }
    return plan.incomplete(shift);
  }

  /// GETS
  /// --------------------------------------------------------------------------
  /// OPERATIONS

  void _markAsComplete() {
    if (plan.isEmpty || _controller.isResting.value) return;
    cubit.markAsComplete(_controller.currentExercise);
  }

  void _play() async {
    await Future.delayed(Duration(milliseconds: 100));
    _controller.togglePlayPause();
  }

  void _start(ExerciseStatus status) {
    if (status == ExerciseStatus.exercise) {
      // _speak(_controller.currentExercise.name);
    } else {
      _speak(localize("rest", defaultValue: "Rest"));
    }
  }

  void _next(ExerciseStatus status) {
    if (_labelController.index >= _labelController.length - 1) return;
    _labelController.index = _labelController.index + 1;
    _labelController.animateTo(_labelController.index);
    if (status == ExerciseStatus.exercise) {
      _markAsComplete();
    }
  }

  void _finish() {
    _markAsComplete();
    _speak(localize("well_done", defaultValue: "Well done!"));
    context.replace(Routes.exerciseDone, arguments: null);
  }

  Future<bool> _pop() async {
    return true;
  }

  Future<bool> _close() {
    return QuitDialog.show(
      context,
      title: localize(
        "quit_dialog_title",
        defaultValue: 'Do you want to Quit?',
      ),
      positiveButtonText: localize(
        "quit_dialog_positive_button",
        defaultValue: "Quit",
      ),
      negativeButtonText: localize(
        "quit_dialog_negative_button",
        defaultValue: "Cancel",
      ),
    ).then((value) {
      if (value is! bool || !value || !mounted) return false;
      context.close();
      return true;
    });
  }

  String get status =>
      localizes(
        "statuses",
        defaultValue: ["Squeeze", "Hold", "Relax"],
      ).elementAtOrNull(_controller.feedback.value) ??
      localize("default_status", defaultValue: "Squeeze");

  void _status() {
    _haptic(0);
    _speak(status);
  }

  void _init() {
    _controller.initialize(
      exercises: exercises,
      localizations: {"rest": localize("rest", defaultValue: "Rest")},
      onStart: _start,
      onComplete: _next,
      onFinish: _finish,
    );
    _controller.feedback.addListener(_status);
  }

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    Speech.init();
    _init();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _controller.feedback.removeListener(() {
      _haptic(1);
    });
    _labelController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InAppScreen(
      onWillPop: _pop,
      child: _initialCountdown ? _buildCountdown() : _buildBody(),
    );
  }

  Widget _buildCountdown() {
    return InAppScreen(
      child: CountdownText(
        onFinish: () async {
          setState(() => _initialCountdown = false);
          _play();
        },
        data: List.generate(3, (index) => "${index + 1}").reversed.toList(),
      ),
    );
  }

  Widget _buildBody() {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.landscape) {
          return ExerciseLandscapeMode(
            controller: _controller,
            labelController: _labelController,
            isHapticEnabled: _isHapticEnabled,
            isSpeechEnabled: _isSpeechEnabled,
            onClose: _close,
            toggleHaptic: _toggleHaptic,
            toggleSpeech: _toggleSpeech,
          );
        }
        return ExercisePortraitMode(
          controller: _controller,
          labelController: _labelController,
          isHapticEnabled: _isHapticEnabled,
          isSpeechEnabled: _isSpeechEnabled,
          onClose: _close,
          toggleHaptic: _toggleHaptic,
          toggleSpeech: _toggleSpeech,
        );
      },
    );
  }

  @override
  String get name => "exercise:main";
}
