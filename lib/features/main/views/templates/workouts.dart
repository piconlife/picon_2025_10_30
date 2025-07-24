import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '/configs/extensions/text_direction.dart';
import '../../../../data/entities/exercise.dart';
import '../../../../data/services/manager.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/item_builder.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/padding.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';
import '../widgets/title.dart';

class Workouts extends StatefulWidget {
  const Workouts({super.key});

  @override
  State<Workouts> createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> with ColorMixin, TranslationMixin {
  void _next(Exercise exercise) {
    context.open(
      Routes.exercise,
      arguments: {
        "exercises": [exercise],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return InAppLayout(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InAppPadding(
          padding: const EdgeInsets.only(
            bottom: 12.0,
            left: 20,
            right: 20,
          ).apply(dimen),
          child: Header(localize("workout_title", defaultValue: "Workouts")),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(horizontal: 20).apply(dimen),
          child: ListenableBuilder(
            listenable: ExerciseManager.i,
            builder: (context, child) {
              List<Exercise> exercises = ExerciseManager.i.exercises;
              return InAppItemBuilder(
                itemCount: exercises.length,
                spacing: dimen.dp(8),
                direction: Axis.vertical,
                itemBuilder: (context, index) {
                  final item = exercises[index];
                  return _buildExercise(index, item);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExercise(int index, Exercise exercise) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dark.withValues(alpha: 0.12), width: 1.5),
      ),
      child: InAppLayout(
        layout: LayoutType.row,
        children: [
          AspectRatio(
            aspectRatio: 14 / 10,
            child: Container(
              padding: const EdgeInsets.only(right: 16).directional,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: InAppImage(
                exercise.thumbnail,
                textDirectionalFlip: true,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: InAppText(
              localize(
                exercise.name,
                defaultValue: exercise.nameOrNull ?? "Unknown",
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
          SizedBox(width: 16),
          InAppGesture(
            onTap: () => _next(exercise),
            child: InAppIcon(Icons.play_circle, color: primary, size: 32),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }

  @override
  String get name => "main:home";
}
