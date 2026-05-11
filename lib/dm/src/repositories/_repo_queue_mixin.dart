part of 'base.dart';

mixin _RepoQueueMixin<T extends Entity> on _RepoExecutorMixin<T> {
  String get queueId;

  Duration get backupFlushInterval;

  int get backupFlushSize;

  String get _queueKey => 'data_repo:queue:$queueId';

  String get _restoredKey => 'data_repo:restored:$queueId';

  Timer? _flushTimer;
  bool _flushing = false;
  int _scheduledCount = 0;

  void _initQueue() {
    DataRepoGlobal.i.register(_queueKey, drainQueue);
    drainQueue();
  }

  void _disposeQueue() {
    _flushTimer?.cancel();
    _flushTimer = null;
    DataRepoGlobal.i.unregister(_queueKey);
  }

  Future<void> drainQueue() async {
    if (isLocalDB) {
      await _drainBackupQueue();
    } else {
      await _drainPrimaryQueue();
    }
  }

  Future<void> _enqueuePrimary(DataQueuedOp op) async {
    final cache = DataRepoGlobal.i.cache;
    if (cache == null) return;
    try {
      await cache.push(_queueKey, op.id, op.toJson());
    } catch (e, s) {
      _report('enqueuePrimary', e, s);
    }
  }

  void _scheduleBackup(DataQueuedOp op) {
    if (optional == null) return;
    final cache = DataRepoGlobal.i.cache;
    if (cache == null) return;
    cache
        .push(_queueKey, op.id, op.toJson())
        .then((_) {
          _scheduledCount++;
          if (_scheduledCount >= backupFlushSize) {
            _scheduledCount = 0;
            flushBackupNow();
            return;
          }
          _flushTimer ??= Timer(backupFlushInterval, () {
            _flushTimer = null;
            _scheduledCount = 0;
            flushBackupNow();
          });
        })
        .catchError((Object e, StackTrace s) {
          _report('scheduleBackup', e, s);
        });
  }

  Future<void> flushBackupNow() async {
    if (_flushing) return;
    final backup = optional;
    if (backup == null) return;
    final cache = DataRepoGlobal.i.cache;
    if (cache == null) return;
    final connected = await isConnected;
    if (!connected) return;
    _flushTimer?.cancel();
    _flushTimer = null;
    _flushing = true;
    try {
      final entries = await cache.readAll(_queueKey);
      for (final entry in entries) {
        try {
          final op = DataQueuedOp.fromJson(entry.value);
          final response = await _replay(op, backup);
          if (response.isSuccessful) {
            await cache.remove(_queueKey, entry.key);
          } else {
            break;
          }
        } catch (e, s) {
          _report('flushBackup', e, s);
        }
      }
    } finally {
      _flushing = false;
    }
  }

  Future<void> _drainPrimaryQueue() async {
    if (_flushing) return;
    final cache = DataRepoGlobal.i.cache;
    if (cache == null) return;
    if (!await isConnected) return;
    _flushing = true;
    try {
      final entries = await cache.readAll(_queueKey);
      for (final entry in entries) {
        try {
          final op = DataQueuedOp.fromJson(entry.value);
          final response = await _replay(op, primary);
          if (response.isSuccessful) {
            await cache.remove(_queueKey, entry.key);
          } else {
            break;
          }
        } catch (e, s) {
          _report('drainPrimary', e, s);
        }
      }
    } finally {
      _flushing = false;
    }
  }

  Future<void> _drainBackupQueue() => flushBackupNow();

  Future<Response<T>> _replay(DataQueuedOp op, DataSource<T> target) async {
    try {
      switch (op.kind) {
        case DataQueuedOpKind.create:
          final eid = op.entityId;
          final data = op.data;
          if (eid == null || data == null) {
            return Response(status: Status.invalid);
          }
          return target.create(
            eid,
            data,
            merge: op.merge,
            createRefs: op.createRefs,
          );
        case DataQueuedOpKind.creates:
          final raws = op.writers ?? const [];
          final writers =
              raws
                  .map(
                    (e) => DataWriter(
                      id: (e['id'] as String?) ?? '',
                      data:
                          ((e['data'] as Map?) ?? const {})
                              .cast<String, dynamic>(),
                    ),
                  )
                  .where((w) => w.id.isNotEmpty)
                  .toList();
          if (writers.isEmpty) return Response(status: Status.invalid);
          return target.creates(
            writers,
            merge: op.merge,
            createRefs: op.createRefs,
          );
        case DataQueuedOpKind.updateById:
          final eid = op.entityId;
          final data = op.data;
          if (eid == null || data == null) {
            return Response(status: Status.invalid);
          }
          return target.updateById(eid, data, updateRefs: op.updateRefs);
        case DataQueuedOpKind.updateByWriters:
          final raws = op.writers ?? const [];
          final writers =
              raws
                  .map(
                    (e) => DataWriter(
                      id: (e['id'] as String?) ?? '',
                      data:
                          ((e['data'] as Map?) ?? const {})
                              .cast<String, dynamic>(),
                    ),
                  )
                  .where((w) => w.id.isNotEmpty)
                  .toList();
          if (writers.isEmpty) return Response(status: Status.invalid);
          return target.updateByWriters(writers, updateRefs: op.updateRefs);
        case DataQueuedOpKind.deleteById:
          final eid = op.entityId;
          if (eid == null) return Response(status: Status.invalid);
          return target.deleteById(
            eid,
            counter: op.counter,
            deleteRefs: op.deleteRefs,
          );
        case DataQueuedOpKind.deleteByIds:
          final ids = op.ids ?? const <String>[];
          if (ids.isEmpty) return Response(status: Status.invalid);
          return target.deleteByIds(
            ids,
            counter: op.counter,
            deleteRefs: op.deleteRefs,
          );
        case DataQueuedOpKind.clear:
          return target.clear(counter: op.counter, deleteRefs: op.deleteRefs);
      }
    } catch (e) {
      return Response(status: Status.failure, error: e.toString());
    }
  }

  Future<bool> _isRestored() async {
    final cache = DataRepoGlobal.i.cache;
    if (cache == null) return false;
    try {
      return await cache.exists(_restoredKey, 'flag');
    } catch (e, s) {
      _report('isRestored', e, s);
      return false;
    }
  }

  Future<void> _markRestored() async {
    final cache = DataRepoGlobal.i.cache;
    if (cache == null) return;
    try {
      await cache.push(_restoredKey, 'flag', {
        'at': DateTime.now().microsecondsSinceEpoch,
      });
    } catch (e, s) {
      _report('markRestored', e, s);
    }
  }

  Future<void> clearRestoredFlag() async {
    final cache = DataRepoGlobal.i.cache;
    if (cache == null) return;
    try {
      await cache.remove(_restoredKey, 'flag');
    } catch (e, s) {
      _report('clearRestoredFlag', e, s);
    }
  }
}
