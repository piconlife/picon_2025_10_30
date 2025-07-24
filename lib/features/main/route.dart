import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes/builder.dart';
import '../../routes/paths.dart';
import '../exercise/data/cubits/daily_plan.dart';
import 'views/pages/main.dart';
import 'views/pages/streak.dart';

Map<String, RouteBuilder> get kMainRoutes {
  return {Routes.home: _main, Routes.streak: _streak};
}

Widget _main(BuildContext context, Object? args) {
  return MultiBlocProvider(
    providers: [BlocProvider(create: (context) => DailyPlanCubit()..load())],
    child: MainPage(args: args),
  );
}

Widget _streak(BuildContext context, Object? args) {
  return StreakPage(args: args);
}
