import 'package:hive_flutter/adapters.dart';

import 'action.dart';

class FollowQueue {
  final _box = Hive.box<FollowAction>(kFollowActionHiveKey);

  Future<void> add(FollowAction action) async => await _box.add(action);

  List<FollowAction> getAll() => _box.values.toList();

  Future<void> remove(FollowAction action) async {
    final key = _box.keys.firstWhere((k) => _box.get(k) == action);
    await _box.delete(key);
  }

  Future<void> clear() async => await _box.clear();
}
