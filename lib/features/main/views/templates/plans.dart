import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/enums/shift.dart';
import '../../../../data/models/plan.dart';
import '../../../../data/services/manager.dart';
import '../../../../roots/widgets/align.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/item_builder.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/text.dart';
import '../../../exercise/data/cubits/daily_plan.dart';
import '../../../exercise/views/pages/exercise_plan.dart';
import '../../../exercise/views/widgets/play_pause_button.dart';
import '../widgets/title.dart';

class Plans extends StatefulWidget {
  const Plans({super.key});

  @override
  State<Plans> createState() => _PlansState();
}

class _PlansState extends State<Plans> with ColorMixin, TranslationMixin {
  Shift get shift => Shift.detect();

  void _doExercise(DailyPlan plan, [Shift? shift]) {
    shift ??= this.shift;
    ExercisePlanPage.show(
      context: context,
      args: {"$DailyPlanCubit": context.read<DailyPlanCubit>(), "shift": shift},
    );
  }

  void _playExercise(DailyPlan plan, [Shift? shift]) {
    if (plan.incomplete(shift ?? this.shift).isEmpty) return;
    _doExercise(plan, shift);
    // shift ??= this.shift;
    // context.open(
    //   Routes.exercise,
    //   arguments: {
    //     "$DailyPlanCubit": context.read<DailyPlanCubit>(),
    //     "shift": shift,
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final planCount = ExerciseManager.i.planCount;
    return BlocBuilder<DailyPlanCubit, DailyPlanCubitState>(
      builder: (context, state) {
        final plan = state.plan;
        final isGenerating = plan.docs.isEmpty;
        final isCompleted = plan.isCompleted(shift);
        final isToday = state.timeline.isToday;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20).apply(dimen),
          child: InAppLayout(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0).apply(dimen),
                child: Header(
                  localize(
                    "daily_goals_title",
                    defaultValue: "Today Goal Progress",
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(16).apply(dimen),
                ),
                padding: EdgeInsets.all(8).apply(dimen),
                child: InAppLayout(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ).apply(dimen),
                      child: InAppLayout(
                        children: [
                          SizedBox(height: 8).apply(dimen),
                          InAppLayout(
                            layout: LayoutType.row,
                            children: [
                              InAppIcon(
                                Icons.extension,
                                color: primary,
                                size: 20,
                              ),
                              SizedBox(width: 8).apply(dimen),
                              InAppText(
                                localize(
                                  "daily_goals_subtitle",
                                  defaultValue: "Kegel exercise",
                                ),
                              ),
                              Spacer(),
                              if (!isGenerating && !isCompleted && isToday)
                                InAppGesture(
                                  onTap: () => _playExercise(plan),
                                  child: InAppIcon(
                                    Icons.play_circle,
                                    color: primary,
                                    size: 20,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 12).apply(dimen),
                          Directionality(
                            textDirection: textDirection,
                            child: LinearProgressIndicator(
                              value: isGenerating ? null : plan.progress,
                              minHeight: 4,
                              borderRadius: BorderRadius.circular(24),
                              color: secondary,
                              backgroundColor: secondary.t10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InAppItemBuilder.stack(
                      itemHeight: 95,
                      itemCount: 3,
                      spacing: 8,
                      itemBuilder: (context, index) {
                        return _buildItem(index, planCount, state);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem(int index, int playCount, DailyPlanCubitState state) {
    final plan = state.plan;
    final isGenerating = plan.docs.isEmpty;
    final isToday = state.timeline.isToday;

    final now = DateTime.now();
    final shift = Shift.detect();
    final current = Shift.values[index];
    final count = plan.incomplete(current).length;
    final isFuture = isToday && current.isFuture(now.hour);
    final isRunningShift = isToday && shift == current;

    return InAppLayout(
      layout: LayoutType.stack,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: double.infinity,
          height: 95,
          padding: EdgeInsets.symmetric(
            horizontal: isToday ? 24 : 16,
            vertical: 4,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: light,
            borderRadius: BorderRadius.circular(16),
            border: isRunningShift
                ? Border.all(
                    color: secondary,
                    width: 2.5,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  )
                : null,
          ),
          child: InAppLayout(
            layout: LayoutType.row,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isFuture || !isRunningShift || !isToday) ...[
                InAppIcon(
                  isGenerating
                      ? Icons.more_horiz
                      : isFuture
                      ? Icons.lock_clock_outlined
                      : "assets/icons/ic_${count > 0 ? "cross" : "check"}_regular.svg",
                  color: count > 0 || isGenerating ? primary : secondary,
                ),
                SizedBox(width: 16),
              ],
              Expanded(
                child: InAppLayout(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InAppText(
                      localizes(
                        "daily_goals",
                        defaultValue: [
                          "Morning Kegel",
                          "Noon Kegel",
                          "Night Kegel",
                        ],
                      )[index],
                      style: TextStyle(
                        color: textColor.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    InAppText(
                      localize(
                        "daily_goals_status",
                        defaultValue:
                            '{IS_LOADING ? "Preparing..." : "{COUNT > 0 ? "COUNT exercise left" : "Exercise done"}"}',
                        applyNumber: true,
                        args: {"COUNT": count, "IS_LOADING": isGenerating},
                      ),
                      style: TextStyle(
                        color: textColor.secondary,
                        fontSize: 12,
                      ),
                    ),
                    if (count > 0 && isToday && isRunningShift) ...[
                      SizedBox(height: 8),
                      PlayPauseButton(
                        text: localize(
                          "daily_goals_button",
                          defaultValue:
                              '{COUNT < PLAY_COUNT ? "Resume" : "Play"}',
                          args: {"COUNT": count, "PLAY_COUNT": playCount},
                        ),
                        onTap: () => _doExercise(plan, shift),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        InAppAlign(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: InAppImage(
              "assets/images/home/exercise_tools_${index + 1}_${(count > 0 || isGenerating) && !isRunningShift ? "disabled" : "enabled"}.png",
              height: 120,
              textDirectionalFlip: true,
            ),
          ),
        ),
      ],
    );
  }

  @override
  String get name => "main:home";
}
