import 'package:in_app_database/in_app_database.dart';

import '../../constants/paths.dart';
import '../../models/plan.dart';

class GetTimelinesUseCase {
  GetTimelinesUseCase._();

  static GetTimelinesUseCase? _i;

  static GetTimelinesUseCase get i => _i ??= GetTimelinesUseCase._();

  Future<List<DailyPlan>> call() async {
    final ref = InAppDatabase.i.collection(Paths.timeline);
    return ref.get().then((value) async {
      if (value.exists) {
        final plans = value.docs.map((e) => DailyPlan.parse(e.data)).toList();
        return plans;
      }
      return [];
    });
  }
}
