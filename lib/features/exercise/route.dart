import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/object.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes/builder.dart';
import '../../routes/paths.dart';
import 'data/cubits/daily_plan.dart';
import 'views/pages/exercise.dart';
import 'views/pages/exercise_done.dart';
import 'views/pages/exercise_plan.dart';

Map<String, RouteBuilder> get kExerciseRoutes {
  return {
    Routes.exercise: _exercise,
    Routes.exercisePlan: _exercisePlan,
    Routes.exerciseDone: _exerciseDone,
  };
}

Widget _exercise(BuildContext context, Object? args) {
  final dailyPlanCubit = args.getOrNull("$DailyPlanCubit");
  return MultiBlocProvider(
    providers: [
      dailyPlanCubit is DailyPlanCubit
          ? BlocProvider.value(value: dailyPlanCubit)
          : BlocProvider(create: (context) => DailyPlanCubit()),
    ],
    child: ExercisePage(args: args),
  );
}

Widget _exercisePlan(BuildContext context, Object? args) {
  final dailyPlanCubit = args.getOrNull("$DailyPlanCubit");
  return MultiBlocProvider(
    providers: [
      dailyPlanCubit is DailyPlanCubit
          ? BlocProvider.value(value: dailyPlanCubit)
          : BlocProvider(create: (context) => DailyPlanCubit()),
    ],
    child: ExercisePlanPage(args: args),
  );
}

Widget _exerciseDone(BuildContext context, Object? args) {
  final dailyPlanCubit = args.getOrNull("$DailyPlanCubit");
  return MultiBlocProvider(
    providers: [
      dailyPlanCubit is DailyPlanCubit
          ? BlocProvider.value(value: dailyPlanCubit)
          : BlocProvider(create: (context) => DailyPlanCubit()),
    ],
    child: ExerciseDonePage(args: args),
  );
}
