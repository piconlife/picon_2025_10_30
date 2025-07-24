import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/object.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../configs/extensions/text_direction.dart';
import '../../../../data/models/plan.dart';
import '../../../../data/use_cases/timeline/get_timelines.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/system_overlay.dart';
import '../../../../roots/widgets/text.dart';
import '../logics/score_service.dart';
import '../widgets/streak_timeline.dart';

class StreakPage extends StatefulWidget {
  final Object? args;

  const StreakPage({super.key, this.args});

  @override
  State<StreakPage> createState() => _StreakPageState();
}

class _StreakPageState extends State<StreakPage>
    with ColorMixin, TranslationMixin {
  int currentStreakCount = Streak.i.value;
  int completedExerciseCount = 0;
  List<DailyPlan> plans = [];

  Future<bool> _back() async {
    context.close();
    return true;
  }

  void _calculateCompletes() {
    completedExerciseCount = plans.fold(0, (a, b) {
      return a + b.completes.toSet().length;
    });
  }

  void _fetchData() {
    GetTimelinesUseCase.i().then((value) {
      setState(() {
        plans = value;
        _calculateCompletes();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return InAppSystemOverlay(
      child: InAppScreen(
        onWillPop: _back,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: InAppAppbar(
            titleText: localize("title", defaultValue: "Progress"),
            titleStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            centerTitle: true,
          ),
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.only(top: 16, bottom: 100),
              children: [_buildCards(), _buildTimeline(), _buildLegend()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 98,
        child: InAppLayout(
          layout: LayoutType.row,
          children: [
            {
              "title": localize(
                'streak_title',
                defaultValue: "{COUNT} Days",
              ).replaceAll("{COUNT}", currentStreakCount.trNumber),
              "subtitle": localize(
                "streak_subtitle",
                defaultValue: "Current Streak",
              ),
              "icon": "assets/icons/ic_fire.svg",
            },
            {
              "title": localize(
                'exercise_title',
                defaultValue: "{COUNT} Exercise",
              ).replaceAll("{COUNT}", completedExerciseCount.trNumber),
              "subtitle": localize(
                "exercise_subtitle",
                defaultValue: "Complete",
              ),
              "icon": "assets/icons/ic_circular_checked.svg",
            },
          ].map(_buildCard).toList(),
        ),
      ),
    );
  }

  Widget _buildCard(Map data) {
    final title = data.get('title', '');
    final subtitle = data.get('subtitle', '');
    final icon = data.get('icon', '');
    return Expanded(
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: dark.t10),
        ),
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.only(left: 16, right: 8).directional,
        child: InAppLayout(
          layout: LayoutType.row,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InAppImage(icon, width: 36, height: 36),
            SizedBox(width: 16),
            Expanded(
              child: InAppLayout(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InAppText(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: dark,
                    ),
                  ),
                  InAppText(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: dark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: dark.t10),
        ),
        child: TimelineChart(
          data: Map.fromEntries(
            plans.map((e) {
              final key = DateTime.parse(e.id);
              final value = TimelineData(
                progress: e.progress,
                completed: e.isFinish,
                date: key,
              );
              return MapEntry(key, value);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: InAppLayout(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InAppText(
            localize("legend_title", defaultValue: "Session Completed"),
            style: TextStyle(
              color: dark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          ...List.generate(4, _buildLegendItem),
        ],
      ),
    );
  }

  Widget _buildLegendItem(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: InAppLayout(
        layout: LayoutType.row,
        children: [
          Container(
            width: 24,
            height: 24,
            padding: index == 2 ? EdgeInsets.all(2) : null,
            decoration: index == 3
                ? null
                : BoxDecoration(
                    color: [primary, secondary, mid.t20].elementAtOrNull(index),
                    shape: BoxShape.circle,
                  ),
            child: index == 3
                ? CircularProgressIndicator(
                    color: secondary,
                    backgroundColor: mid.t20,
                    value: 1 / 3,
                    strokeCap: StrokeCap.round,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          InAppText(
            localizes(
              "legends",
              defaultValue: ["Today", "Completed", "Missed", "Uncompleted"],
            ).elementAtOrNull(index),
            style: TextStyle(fontSize: 16, color: dark),
          ),
        ],
      ),
    );
  }

  @override
  String get name => "streak:main";
}
