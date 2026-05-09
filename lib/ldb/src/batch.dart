import 'database.dart';

enum _BatchOpType { set, update, delete }

class _BatchOp {
  final _BatchOpType type;
  final InAppDocumentReference document;
  final InAppDocument? data;
  final InAppSetOptions options;

  const _BatchOp({
    required this.type,
    required this.document,
    this.data,
    this.options = InAppSetOptions.defaults,
  });
}

class _BatchSnapshot {
  final InAppDocumentReference document;
  final InAppDocument? previousData;
  final bool existed;

  const _BatchSnapshot({
    required this.document,
    required this.previousData,
    required this.existed,
  });
}

class InAppWriteBatch {
  final InAppDatabase _db;
  final List<_BatchOp> _operations = [];
  bool _committed = false;

  InAppWriteBatch._(this._db);

  factory InAppWriteBatch() => InAppWriteBatch._(InAppDatabase.instance);

  factory InAppWriteBatch.of(InAppDatabase db) => InAppWriteBatch._(db);

  int get length => _operations.length;

  bool get isEmpty => _operations.isEmpty;

  bool get isNotEmpty => _operations.isNotEmpty;

  bool get isCommitted => _committed;

  void set(
    InAppDocumentReference document,
    InAppDocument data, [
    InAppSetOptions options = InAppSetOptions.defaults,
  ]) {
    _ensureNotCommitted();
    _ensureSameDatabase(document);
    _operations.add(
      _BatchOp(
        type: _BatchOpType.set,
        document: document,
        data: Map<String, InAppValue>.of(data),
        options: options,
      ),
    );
  }

  void update(InAppDocumentReference document, InAppDocument data) {
    _ensureNotCommitted();
    _ensureSameDatabase(document);
    _operations.add(
      _BatchOp(
        type: _BatchOpType.update,
        document: document,
        data: Map<String, InAppValue>.of(data),
      ),
    );
  }

  void delete(InAppDocumentReference document) {
    _ensureNotCommitted();
    _ensureSameDatabase(document);
    _operations.add(_BatchOp(type: _BatchOpType.delete, document: document));
  }

  Future<void> commit() async {
    _ensureNotCommitted();
    _committed = true;

    if (_operations.isEmpty) return;

    final ops = List<_BatchOp>.unmodifiable(_operations);
    _operations.clear();

    final snapshots = await _captureSnapshots(ops);
    final completed = <int>[];

    try {
      for (var i = 0; i < ops.length; i++) {
        await _executeOp(ops[i]);
        completed.add(i);
      }
    } catch (error, stack) {
      await _rollback(completed, snapshots);
      Error.throwWithStackTrace(error, stack);
    }
  }

  Future<List<_BatchSnapshot>> _captureSnapshots(List<_BatchOp> ops) async {
    final snapshots = <_BatchSnapshot>[];
    for (final op in ops) {
      final existing = await op.document.get();
      snapshots.add(
        _BatchSnapshot(
          document: op.document,
          previousData:
              existing.data == null
                  ? null
                  : Map<String, InAppValue>.of(existing.data!),
          existed: existing.exists,
        ),
      );
    }
    return snapshots;
  }

  Future<void> _executeOp(_BatchOp op) async {
    switch (op.type) {
      case _BatchOpType.set:
        final result = await op.document.set(op.data!, op.options);
        if (result == null) {
          throw InAppDatabaseException(
            'Batch set failed for "${op.document.path}".',
          );
        }
        break;
      case _BatchOpType.update:
        final result = await op.document.update(op.data!);
        if (result == null) {
          throw InAppDatabaseException(
            'Batch update failed for "${op.document.path}".',
          );
        }
        break;
      case _BatchOpType.delete:
        final ok = await op.document.delete();
        if (!ok) {
          throw InAppDatabaseException(
            'Batch delete failed for "${op.document.path}".',
          );
        }
        break;
    }
  }

  Future<void> _rollback(
    List<int> completedIndexes,
    List<_BatchSnapshot> snapshots,
  ) async {
    for (var i = completedIndexes.length - 1; i >= 0; i--) {
      final snap = snapshots[completedIndexes[i]];
      try {
        if (snap.existed && snap.previousData != null) {
          await snap.document.set(snap.previousData!);
        } else {
          await snap.document.delete();
        }
      } catch (_) {}
    }
  }

  void _ensureNotCommitted() {
    if (_committed) {
      throw StateError(
        'A write batch can no longer be used after commit() has been called.',
      );
    }
  }

  void _ensureSameDatabase(InAppDocumentReference document) {
    if (!identical(document.database, _db)) {
      throw ArgumentError(
        'The document "${document.path}" belongs to a different InAppDatabase instance.',
      );
    }
  }
}
