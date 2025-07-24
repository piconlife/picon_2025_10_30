import 'package:flutter_andomie/utils/date_helper.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../constants/paths.dart';
import '../../models/plan.dart';
import '../../services/manager.dart';

class GetTimelineUseCase {
  GetTimelineUseCase._();

  static GetTimelineUseCase? _i;

  static GetTimelineUseCase get i => _i ??= GetTimelineUseCase._();

  Future<DailyPlan> call([DateTime? timeline]) async {
    timeline ??= DateTime.now();
    final ref = InAppDatabase.i.collection(Paths.timeline).doc(timeline.date);
    return ref.get().then((value) async {
      if (value.exists) {
        final plan = DailyPlan.parse(value.data);
        if (!plan.isEmpty) return plan;
      }
      final plan = ExerciseManager.i.generateDailyPlan(timeline);
      await ref.set(plan.source);
      return plan;
    });
  }
}
