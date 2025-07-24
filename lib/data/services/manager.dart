import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_andomie/core.dart';

import '../entities/exercise.dart';
import '../enums/shift.dart';
import '../models/plan.dart';

const _kExercisePlanCount = "exercise_plan_count";

class ExerciseManager extends ChangeNotifier {
  ExerciseManager._();

  static ExerciseManager? _i;

  static ExerciseManager get i => _i ??= ExerciseManager._();

  bool get isInitialing {
    return animationInitializing || exerciseInitializing;
  }

  bool get isInitialized => !isInitialing;

  static Future<void> init() async {
    await i._initAnimations();
    await i._initExercises();
  }

  // ---------------------------------------------------------------------------
  // ANIMATION EXERCISES START
  // ---------------------------------------------------------------------------

  bool animationInitializing = false;

  final Map<String, Exercise> _animations = {};

  List<Exercise> get animations => _animations.values.toList();

  List<Exercise> get morningAnimationExercises {
    return List.from(
      animations.where((e) {
        return e.preferredShift.isMorning;
      }),
    );
  }

  List<Exercise> get noonAnimationExercises {
    return List.from(
      animations.where((e) {
        return e.preferredShift.isDay;
      }),
    );
  }

  List<Exercise> get nightAnimationExercises {
    return List.from(
      animations.where((e) {
        return e.preferredShift.isNight;
      }),
    );
  }

  List<Exercise> get anyAnimationExercises {
    return List.from(animations.where((e) => e.preferredShift.isAny));
  }

  Future<void> _initAnimations() async {
    try {
      animationInitializing = true;
      notifyListeners();
      final raw = await rootBundle.loadString(
        "assets/contents/animations.json",
      );
      animationInitializing = false;
      final decoded = jsonDecode(raw);
      if (decoded is! List || decoded.isEmpty) return notifyListeners();

      final localizations = Translation.get(
        path: 'animations',
        defaultValue: {},
      );

      final localizedAnimations = decoded
          .map((e) {
            final item = Exercise.parse(e);
            if (item.isEmpty) return null;
            return MapEntry(item.id, item.localize(localizations?[item.id]));
          })
          .whereType<MapEntry<String, Exercise>>()
          .toList();

      if (localizedAnimations.isEmpty) return notifyListeners();

      _animations.addEntries(localizedAnimations);
      notifyListeners();
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // ANIMATION EXERCISES END
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // PREVIEW EXERCISES START
  // ---------------------------------------------------------------------------

  bool exerciseInitializing = false;

  final Map<String, Exercise> _exercises = {};

  List<Exercise> get exercises => _exercises.values.toList();

  List<Exercise> get morningPreviewExercises {
    return List.from(
      exercises.where((e) {
        return e.preferredShift.isMorning;
      }),
    );
  }

  List<Exercise> get noonPreviewExercises {
    return List.from(exercises.where((e) => e.preferredShift.isDay));
  }

  List<Exercise> get nightPreviewExercises {
    return List.from(exercises.where((e) => e.preferredShift.isNight));
  }

  List<Exercise> get anyPreviewExercises {
    return List.from(exercises.where((e) => e.preferredShift.isAny));
  }

  Future<void> _initExercises() async {
    try {
      exerciseInitializing = true;
      notifyListeners();
      final raw = await rootBundle.loadString("assets/contents/exercises.json");
      exerciseInitializing = false;
      final decoded = jsonDecode(raw);
      if (decoded is! List || decoded.isEmpty) return notifyListeners();

      final localizations = Translation.get(
        path: 'exercises',
        defaultValue: {},
      );

      final localizedExercises = decoded
          .map((e) {
            final item = Exercise.parse(e);
            if (item.isEmpty || !item.type.isVideo) return null;
            return MapEntry(item.id, item.localize(localizations?[item.id]));
          })
          .whereType<MapEntry<String, Exercise>>()
          .toList();

      if (localizedExercises.isEmpty) return notifyListeners();

      _exercises.addEntries(localizedExercises);
      notifyListeners();
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // PREVIEW EXERCISES END
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // EXERCISE GENERATING START
  // ---------------------------------------------------------------------------

  int get planCount => Settings.get(_kExercisePlanCount, 5);

  bool loading = false;

  final Map<String, DailyPlan> _plans = {};

  Map<String, DailyPlan> get plans => _plans;

  Exercise getExerciseById(String id) {
    Exercise? exercise = _exercises[id] ?? _animations[id];
    if (exercise == null || exercise.isEmpty) return Exercise.empty();
    return exercise;
  }

  List<Exercise> getExerciseByIds(Iterable<String> ids) {
    return ids.map(getExerciseById).toList();
  }

  DailyPlan generateDailyPlan([DateTime? timeline]) {
    timeline ??= DateTime.now();

    final mergedMorning = [
      ...morningAnimationExercises,
      ...anyAnimationExercises,
      ...morningPreviewExercises,
      ...anyPreviewExercises,
    ];
    final mergedNoon = [
      ...noonAnimationExercises,
      ...anyAnimationExercises,
      ...noonPreviewExercises,
      ...anyPreviewExercises,
    ];
    final mergedNight = [
      ...nightAnimationExercises,
      ...anyAnimationExercises,
      ...nightPreviewExercises,
      ...anyPreviewExercises,
    ];

    mergedMorning.shuffle();
    mergedNoon.shuffle();
    mergedNight.shuffle();

    final generatedMorning = mergedMorning
        .take(planCount)
        .map((e) => e.copy(preferredShift: Shift.morning));
    final generatedNoon = mergedNoon
        .take(planCount)
        .map((e) => e.copy(preferredShift: Shift.day));
    final generatedNight = mergedNight
        .take(planCount)
        .map((e) => e.copy(preferredShift: Shift.night));

    final result = [...generatedMorning, ...generatedNoon, ...generatedNight];

    return DailyPlan(
      id: timeline.date,
      timeMills: timeline.millisecondsSinceEpoch,
      docs: result.map((e) => e.idWithShift).toList(),
      completes: [],
    );
  }
}
