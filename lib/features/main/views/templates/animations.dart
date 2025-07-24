import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../data/entities/exercise.dart';
import '../../../../data/services/manager.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/item_builder.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';
import '../../../exercise/views/widgets/play_pause_button.dart';
import '../widgets/title.dart';

class Animations extends StatefulWidget {
  const Animations({super.key});

  @override
  State<Animations> createState() => _AnimationsState();
}

class _AnimationsState extends State<Animations>
    with ColorMixin, TranslationMixin {
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
        Padding(
          padding: const EdgeInsets.only(
            bottom: 12.0,
            left: 20,
            right: 20,
          ).apply(dimen),
          child: Header(localize("exercise_title", defaultValue: "Exercises")),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20).apply(dimen),
          child: ListenableBuilder(
            listenable: ExerciseManager.i,
            builder: (context, child) {
              List<Exercise> exercises = ExerciseManager.i.animations;
              return InAppItemBuilder(
                itemCount: exercises.length,
                spacing: dimen.dp(8),
                direction: Axis.horizontal,
                itemBuilder: (context, index) {
                  final item = exercises[index];
                  return _buildItem(index, item);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItem(int index, Exercise exercise) {
    final dimen = context.dimens;
    return Container(
      height: 150,
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFDDDDDD)),
        borderRadius: BorderRadius.circular(16).apply(dimen),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16).apply(dimen),
      child: InAppLayout(
        layout: LayoutType.stack,
        children: [
          SizedBox(height: 8).apply(dimen),
          Align(
            alignment: Alignment(0, -2.5),
            child: Transform.scale(
              scale: 1.4,
              child: InAppImage(
                exercise.thumbnailOrNull,
                tint: secondary,
                textDirectionalFlip: true,
                width: 120,
                // size: 30,
                // flipByTextDirection: true,
              ),
            ),
          ),
          SizedBox(height: 12.5).apply(dimen),
          Align(
            alignment: Alignment.bottomCenter,
            child: InAppLayout(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InAppText(
                  localize(
                    exercise.name,
                    defaultValue: exercise.nameOrNull ?? "Unknown",
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: dark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16).apply(dimen),
                PlayPauseButton(
                  text: localize("daily_goal_button_1", defaultValue: "Play"),
                  onTap: () => _next(exercise),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  String get name => "main:home";
}
