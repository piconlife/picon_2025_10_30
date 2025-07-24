import 'package:flutter_andomie/utils/date_helper.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../constants/paths.dart';

class UpdateTimelineUseCase {
  UpdateTimelineUseCase._();

  static UpdateTimelineUseCase? _i;

  static UpdateTimelineUseCase get i => _i ??= UpdateTimelineUseCase._();

  Future<void> call({
    DateTime? timeline,
    Map<String, dynamic> data = const {},
  }) async {
    timeline ??= DateTime.now();
    InAppDatabase.i.collection(Paths.timeline).doc(timeline.date).update(data);
  }
}
