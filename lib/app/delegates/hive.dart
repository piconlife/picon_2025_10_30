import 'package:hive_flutter/adapters.dart';

import '../../data/managers/follow/action.dart';
import '../../roots/hive/config.dart';

class InAppHiveConfiguration extends HiveConfigure {
  @override
  Future<void> openBox() async {
    await Hive.openBox<FollowAction>(kFollowActionHiveKey);
  }

  @override
  Future<void> registerAdapter() async {
    Hive.registerAdapter(FollowActionAdapter());
  }
}
