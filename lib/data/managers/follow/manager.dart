import '../../../roots/helpers/connectivity.dart';
import 'action.dart';
import 'executor.dart';
import 'queue.dart';

class FollowWriteManager {
  final FollowQueue queue;
  final FollowExecutor executor;

  bool _syncing = false;

  static FollowWriteManager? _i;

  static FollowWriteManager get i {
    return _i ??= FollowWriteManager(FollowQueue(), FollowExecutor());
  }

  FollowWriteManager(this.queue, this.executor) {
    ConnectivityHelper.changed.listen((status) {
      if (status) trySync();
    });
  }

  Future<void> enqueue(FollowAction action) async {
    await queue.add(action);
    trySync();
  }

  Future<void> trySync() async {
    if (_syncing) return;

    final status = await ConnectivityHelper.isDisconnected;
    if (status) return;

    _syncing = true;

    try {
      final actions = _collapse(queue.getAll());

      for (final action in actions) {
        try {
          await executor.execute(action);
          await queue.remove(action);
        } catch (_) {
          break; // stop on first failure
        }
      }
    } finally {
      _syncing = false;
    }
  }

  List<FollowAction> _collapse(List<FollowAction> actions) {
    final map = <String, FollowAction>{};
    for (final a in actions) {
      map[a.otherUid] = a;
    }
    return map.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }
}
