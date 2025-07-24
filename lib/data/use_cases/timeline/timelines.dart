import 'package:in_app_database/in_app_database.dart';

import '../../constants/paths.dart';

class TimelinesUseCase {
  TimelinesUseCase._();

  static TimelinesUseCase? _i;

  static TimelinesUseCase get i => _i ??= TimelinesUseCase._();

  Future<List<DateTime>> call() async {
    return InAppDatabase.i.collection(Paths.timeline).keys.then((value) {
      return value
          .map((e) => DateTime.tryParse(e))
          .whereType<DateTime>()
          .toList();
    });
  }
}
