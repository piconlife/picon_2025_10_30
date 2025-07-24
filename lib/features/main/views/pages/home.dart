import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../exercise/data/cubits/daily_plan.dart';
import '../templates/animations.dart';
import '../templates/plans.dart';
import '../templates/workouts.dart';
import '../widgets/logo.dart';
import '../widgets/streak.dart';
import '../widgets/timeline.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TranslationMixin, ColorMixin {
  DateTime selectedDate = DateTime.now();

  void _changedTimeline(DateTime value) {
    context.read<DailyPlanCubit>().load(value);
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return InAppScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: InAppAppbar(
          elevation: 0,
          backgroundColor: context.appbarColor.primary ?? Colors.transparent,
          leading: InAppLayout(
            layout: LayoutType.row,
            children: [SizedBox(width: 12), BrandedLogo()],
          ),
          centerTitle: false,
          actions: [StreakButton()],
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.only(bottom: 24).apply(dimen),
            children: [
              ColoredBox(
                color: context.appbarColor.primary ?? Colors.transparent,
                child: Timeline(
                  elevationColor: dividerColor.soft,
                  selectedDate: selectedDate,
                  onChanged: _changedTimeline,
                ),
              ),
              SizedBox(height: 24).apply(dimen),
              Plans(),
              SizedBox(height: 24).apply(dimen),
              Animations(),
              SizedBox(height: 24).apply(dimen),
              Workouts(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  String get name => "main:home";
}
