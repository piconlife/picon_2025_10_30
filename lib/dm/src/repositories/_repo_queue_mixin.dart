part of 'base.dart';

mixin _RepoQueueMixin<T extends Entity> on _RepoExecutorMixin<T> {
  static const int _maxAttempts = 5;

  String get queueId;

  Duration get backupFlushInterval;

  int get backupFlushSize;

  String get _queueKey => 'data_repo:queue:$queueId';

  String get _restoredKey => 'data_repo:restored:$queueId';

  Timer? _flushTimer;
  bool _flushing = false;
  int _scheduledCount = 0;

  void _initQueue() {
    DM.i.register(_queueKey, drainQueue);
    drainQueue();
  }

  void _disposeQueue() {
    _flushTimer?.cancel();
    _flushTimer = null;
    _flushing = false;
    _scheduledCount = 0;
    DM.i.unregister(_queueKey);
  }

  Future<void> drainQueue() async {
    if (isLocalDB) {
      await _drainBackupQueue();
    } else {
      await _drainPrimaryQueue();
    }
  }

  Future<void> _enqueuePrimary(DataQueuedOp op) async {
    final cache = DM.i.cache;
    if (cache == null) return;
    try {
      final merged = await _mergeOnPush(cache, op);
      await cache.onPush(_queueKey, op.id, merged.toJson());
    } catch (e, s) {
      _report('enqueuePrimary', e, s);
    }
  }

  Future<void> _scheduleBackup(DataQueuedOp op) async {
    if (optional == null) return;
    final cache = DM.i.cache;
    if (cache == null) return;
    try {
      final merged = await _mergeOnPush(cache, op);
      await cache.onPush(_queueKey, op.id, merged.toJson());
      _scheduledCount++;
      if (_scheduledCount >= backupFlushSize) {
        _scheduledCount = 0;
        _flushTimer?.cancel();
        _flushTimer = null;
        await flushBackupNow();
        return;
      }
      _flushTimer ??= Timer(backupFlushInterval, () {
        _flushTimer = null;
        _scheduledCount = 0;
        flushBackupNow().catchError((e, s) => _report('timerFlush', e, s));
      });
    } catch (e, s) {
      _report('scheduleBackup', e, s);
    }
  }

  Future<DataQueuedOp> _mergeOnPush(
    DataCacheDelegate cache,
    DataQueuedOp incoming,
  ) async {
    final entries = await cache.onReadAll(_queueKey);
    if (entries.isEmpty) return incoming;

    if (incoming.kind == DataQueuedOpKind.clear) {
      for (final entry in entries) {
        await cache.onRemove(_queueKey, entry.key);
      }
      return incoming;
    }

    if (incoming.kind == DataQueuedOpKind.deleteByIds) {
      final targetIds = Set<String>.from(incoming.ids ?? const []);
      if (targetIds.isEmpty) return incoming;
      for (final entry in entries) {
        try {
          final existing = DataQueuedOp.fromJson(entry.value);
          if (_supersededByDeleteIds(existing, targetIds)) {
            await cache.onRemove(_queueKey, entry.key);
          }
        } catch (_) {}
      }
      return incoming;
    }

    final eid = incoming.entityId;
    if (eid == null || eid.isEmpty) return incoming;

    final superseded = <String>[];
    for (final entry in entries) {
      try {
        final existing = DataQueuedOp.fromJson(entry.value);
        if (_supersededByDeleteId(incoming, existing, eid)) {
          superseded.add(entry.key);
        } else if (_supersedes(incoming.kind, existing.kind) &&
            existing.entityId == eid) {
          superseded.add(entry.key);
        }
      } catch (_) {}
    }
    for (final id in superseded) {
      await cache.onRemove(_queueKey, id);
    }
    return incoming;
  }

  bool _supersededByDeleteIds(DataQueuedOp existing, Set<String> targetIds) {
    final eid = existing.entityId;
    if (eid != null && eid.isNotEmpty) {
      if (!targetIds.contains(eid)) return false;
      return existing.kind == DataQueuedOpKind.create ||
          existing.kind == DataQueuedOpKind.updateById ||
          existing.kind == DataQueuedOpKind.deleteById;
    }
    if (existing.kind == DataQueuedOpKind.creates ||
        existing.kind == DataQueuedOpKind.updateByWriters) {
      final writerIds = _writerIds(existing.writers);
      return writerIds.isNotEmpty && writerIds.every(targetIds.contains);
    }
    return false;
  }

  bool _supersededByDeleteId(
    DataQueuedOp incoming,
    DataQueuedOp existing,
    String eid,
  ) {
    if (incoming.kind != DataQueuedOpKind.deleteById) return false;
    if (existing.kind == DataQueuedOpKind.creates ||
        existing.kind == DataQueuedOpKind.updateByWriters) {
      final ids = _writerIds(existing.writers);
      return ids.length == 1 && ids.contains(eid);
    }
    return false;
  }

  Set<String> _writerIds(List<Map<String, dynamic>>? writers) {
    return (writers ?? const [])
        .map((w) => (w['id'] as String?) ?? '')
        .where((id) => id.isNotEmpty)
        .toSet();
  }

  bool _supersedes(DataQueuedOpKind incoming, DataQueuedOpKind existing) {
    switch (incoming) {
      case DataQueuedOpKind.deleteById:
        return existing == DataQueuedOpKind.create ||
            existing == DataQueuedOpKind.updateById;
      case DataQueuedOpKind.updateById:
        return existing == DataQueuedOpKind.updateById;
      case DataQueuedOpKind.create:
        return existing == DataQueuedOpKind.create;
      default:
        return false;
    }
  }

  Future<void> flushBackupNow() async {
    if (_flushing) return;
    _flushing = true;
    try {
      final backup = optional;
      if (backup == null) return;
      final cache = DM.i.cache;
      if (cache == null) return;
      if (!await isConnected) return;
      _flushTimer?.cancel();
      _flushTimer = null;
      await _drain(cache, backup, 'flushBackup');
    } finally {
      _flushing = false;
    }
  }

  Future<void> _drainPrimaryQueue() async {
    if (_flushing) return;
    _flushing = true;
    try {
      final cache = DM.i.cache;
      if (cache == null) return;
      if (!await isConnected) return;
      await _drain(cache, primary, 'drainPrimary');
    } finally {
      _flushing = false;
    }
  }

  Future<void> _drainBackupQueue() => flushBackupNow();

  Future<void> _drain(
    DataCacheDelegate cache,
    DataSource<T> target,
    String tag,
  ) async {
    final entries = await cache.onReadAll(_queueKey);
    for (final entry in entries) {
      DataQueuedOp op;
      try {
        op = DataQueuedOp.fromJson(entry.value);
      } catch (e, s) {
        _report('$tag.decode', e, s);
        await cache.onRemove(_queueKey, entry.key);
        continue;
      }

      Response<T> response;
      try {
        response = await _replay(op, target);
      } catch (e, s) {
        _report('$tag: ${op.kind.name}/${op.entityId}', e, s);
        await _handleFailedOp(cache, entry.key, op);
        break;
      }

      if (response.isSuccessful) {
        await cache.onRemove(_queueKey, entry.key);
        continue;
      }

      if (response.status == Status.invalid) {
        await cache.onRemove(_queueKey, entry.key);
        _report(
          'queue.invalid',
          StateError('invalid op discarded: ${op.kind.name}/${op.entityId}'),
          StackTrace.current,
        );
        continue;
      }

      if (response.status == Status.networkError) {
        break;
      }

      await _handleFailedOp(cache, entry.key, op);
    }
  }

  Future<void> _handleFailedOp(
    DataCacheDelegate cache,
    String entryKey,
    DataQueuedOp op,
  ) async {
    final next = op.copyWith(attempts: op.attempts + 1);
    if (next.attempts >= _maxAttempts) {
      await cache.onRemove(_queueKey, entryKey);
      _report(
        'queue.dropped',
        StateError('op exhausted retries: ${op.kind.name}/${op.entityId}'),
        StackTrace.current,
      );
      return;
    }
    await cache.onPush(_queueKey, entryKey, next.toJson());
  }

  List<DataWriter> _parseWriters(List<Map<String, dynamic>>? raws) {
    return (raws ?? const [])
        .map(
          (e) => DataWriter(
            id: (e['id'] as String?) ?? '',
            data: ((e['data'] as Map?) ?? const {}).cast<String, dynamic>(),
          ),
        )
        .where((w) => w.id.isNotEmpty)
        .toList();
  }

  Future<Response<T>> _replay(DataQueuedOp op, DataSource<T> target) async {
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
        final writers = _parseWriters(op.writers);
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
        final writers = _parseWriters(op.writers);
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
  }

  Future<bool> _isRestored() async {
    final cache = DM.i.cache;
    if (cache == null) return false;
    try {
      return await cache.onExists(_restoredKey, 'flag');
    } catch (e, s) {
      _report('isRestored', e, s);
      return false;
    }
  }

  Future<void> _markRestored() async {
    final cache = DM.i.cache;
    if (cache == null) return;
    try {
      await cache.onPush(_restoredKey, 'flag', {
        'at': DateTime.now().microsecondsSinceEpoch,
      });
    } catch (e, s) {
      _report('markRestored', e, s);
    }
  }

  Future<void> clearRestoredFlag() async {
    final cache = DM.i.cache;
    if (cache == null) return;
    try {
      await cache.onRemove(_restoredKey, 'flag');
    } catch (e, s) {
      _report('clearRestoredFlag', e, s);
    }
  }
}
