import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/res/icons.dart';
import '../../../../configs/extensions/text_direction.dart';
import '../../../../data/entities/exercise.dart';
import '../../../../data/enums/shift.dart';
import '../../../../data/models/plan.dart';
import '../../../../roots/widgets/align.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/system_overlay.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';
import '../../../main/views/widgets/secondary_button.dart';
import '../../data/cubits/daily_plan.dart';

class ExercisePlanPage extends StatefulWidget {
  final bool dialogMode;
  final Object? args;

  const ExercisePlanPage({super.key, this.dialogMode = false, this.args});

  static Future<T?>? show<T extends Object?>({
    required BuildContext context,
    Object? args,
  }) {
    return showAndrossyDialog(
      context: context,
      barrierBlurSigma: 15,
      duration: Duration(milliseconds: 500),
      builder: (context) {
        final dailyPlanCubit = args.getOrNull("$DailyPlanCubit");
        return MultiBlocProvider(
          providers: [
            dailyPlanCubit is DailyPlanCubit
                ? BlocProvider.value(value: dailyPlanCubit)
                : BlocProvider(create: (context) => DailyPlanCubit()),
          ],
          child: ExercisePlanPage(args: args, dialogMode: true),
        );
      },
    );
  }

  @override
  State<ExercisePlanPage> createState() => _ExercisePlanPageState();
}

class _ExercisePlanPageState extends State<ExercisePlanPage>
    with TranslationMixin, ColorMixin {
  int index = 0;

  late final cubit = context.read<DailyPlanCubit>();

  late Shift shift = widget.args.findByKey("shift", defaultValue: Shift.any);

  DailyPlan get plan => cubit.state.plan;

  List<Exercise> get current => plan.total(shift);

  void _go() {
    context.close();
    context.open(Routes.exercise, arguments: widget.args);
    // ExercisePage.show(context: context, args: widget.args);
  }

  @override
  Widget build(BuildContext context) {
    return InAppSystemOverlay(
      child: InAppScreen(
        useBackground: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: InAppAlign(
              alignment: Alignment(0, 0.25),
              child: Container(
                height: context.h * 0.84,
                width: context.w * 0.92,
                decoration: BoxDecoration(
                  color: light,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: InAppLayout(
                  children: [
                    _buildToolbar(),
                    _buildDivider(),
                    _buildExercises(),
                    _buildDivider(),
                    _buildBottom(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return SizedBox(
      height: 65,
      child: InAppLayout(
        layout: LayoutType.stack,
        children: [_buildTitle(), _buildCloseButton()],
      ),
    );
  }

  Widget _buildTitle() {
    return Center(
      child: InAppText(
        localizes(
          "titles",
          defaultValue: ["Morning Kegel", "Noon Kegel", "Night Kegel"],
        ).elementAtOrNull(shift.index),
        style: TextStyle(
          color: secondary,
          fontSize: 19,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return InAppAlign(
      alignment: Alignment(0.95, 0),
      child: InAppGesture(
        onTap: widget.dialogMode ? context.dismiss : context.close,
        child: Container(
          decoration: BoxDecoration(color: Colors.transparent),
          padding: EdgeInsets.all(8),
          child: InAppIcon(InAppIcons.close.regular, size: 27, color: dark.t25),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 0, color: dark.t10);
  }

  Widget _buildExercises() {
    return Expanded(
      child: InAppLayout(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
            child: InAppText(
              localize(
                "exercise_count",
                defaultValue: "{COUNT} Exercises",
                applyNumber: true,
                replace: (value) {
                  return value.replaceAll(
                    "{COUNT}",
                    plan.total(shift).length.toString(),
                  );
                },
              ),
              style: TextStyle(
                color: dark,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: current.length,
              itemBuilder: (context, index) {
                return _buildExercise(index);
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExercise(int index) {
    final exercise = current[index];
    return Container(
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dark.withValues(alpha: 0.12), width: 1.5),
      ),
      child: InAppLayout(
        layout: LayoutType.row,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.only(right: 16).directional,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: InAppImage(exercise.thumbnail, textDirectionalFlip: true),
            ),
          ),
          Expanded(
            flex: 3,
            child: InAppLayout(
              layout: LayoutType.row,
              children: [
                Expanded(
                  child: InAppLayout(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InAppText(
                        localize(
                          exercise.name,
                          defaultValue: exercise.nameOrNull ?? "Unknown",
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      if (exercise.type.isVideo)
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: dark,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          child: InAppText(
                            localize("movement", defaultValue: "Movement"),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: light, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                if (plan.isExercised(exercise.idWithShift))
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ).directional,
                      color: secondary,
                    ),
                    height: 30,
                    width: 40,
                    alignment: Alignment.center,
                    child: InAppIcon(Icons.check, color: light, size: 22),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Container(
      height: 105,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: InAppLayout(
        layout: LayoutType.row,
        children: [
          InAppIcon(Icons.timer_outlined, color: dark),
          SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: InAppLayout(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InAppText(
                  localize("duration_title", defaultValue: "Duration"),
                  style: TextStyle(fontSize: 16, color: dark),
                ),
                SizedBox(height: 4),
                InAppText(
                  localize(
                    "duration_value",
                    defaultValue: "{DURATION_IN_MIN} min",
                    applyNumber: true,
                    replace: (value) {
                      return value.replaceAll(
                        "{DURATION_IN_MIN}",
                        plan.incompleteDuration(shift).inMinutes.toString(),
                      );
                    },
                  ),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: InAppSecondaryButton(
              onTap: _go,
              text: localize("button", defaultValue: "Go"),
              height: 72,
              textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  @override
  String get name => "exercise:plan";
}
