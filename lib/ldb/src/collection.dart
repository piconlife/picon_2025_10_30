part of 'database.dart';

abstract class InAppCollectionReference extends InAppReference {
  final String path;
  final String id;

  const InAppCollectionReference({
    required super.db,
    required super.reference,
    required this.path,
    required this.id,
  });

  Future<List<String>> get keys async {
    final paths = await _db._k(path);
    final prefix = '$reference/';
    final result = <String>{};
    for (final p in paths) {
      if (p == reference) continue;
      if (!p.startsWith(prefix)) continue;
      final remainder = p.substring(prefix.length);
      final first = remainder.split('/').first;
      if (first.isNotEmpty) result.add(first);
    }
    return result.toList(growable: false);
  }

  InAppQueryNotifier? get _notifier {
    final n = _db._notifiers[path];
    return n is InAppQueryNotifier ? n : null;
  }

  T _n<T>(T value, [InAppQuerySnapshot? snapshot]) {
    final n = _notifier;
    if (n == null || n.isDisposed) return value;
    if (snapshot == null) {
      get()
          .then((s) {
            if (!n.isDisposed) n.value = s;
          })
          .catchError((_) {});
    } else {
      n.value = snapshot;
    }
    return value;
  }

  void _notify([InAppQuerySnapshot? snapshot]) => _n<void>(null, snapshot);

  String push() => _id;

  InAppDocumentReference doc(String field) {
    if (field.isEmpty) {
      throw ArgumentError.value(field, 'field', 'Document id cannot be empty.');
    }
    if (field.contains('/')) {
      throw ArgumentError.value(
        field,
        'field',
        'Document id cannot contain "/".',
      );
    }
    return InAppDocumentReference(
      db: _db,
      reference: '$reference/$field',
      id: field,
      parent: this,
    );
  }

  Future<InAppDocumentSnapshot?> add(InAppDocument data) {
    final raw = data[_idField] ?? data[_idFieldSecondary];
    final id = raw is String && raw.isNotEmpty ? raw : _id;
    final payload = Map<String, InAppValue>.of(data);
    payload[_idField] = id;
    return doc(id).set(payload);
  }

  Future<InAppQuerySnapshot?> set(
    List<InAppDocumentSnapshot> data, {
    bool notifiable = false,
  }) async {
    final query = InAppQuerySnapshot(id, data);
    final ok = await _db._w(
      reference: reference,
      collectionPath: path,
      collectionId: id,
      documentId: id,
      type: InAppWriteType.collection,
      value: query.rootDocs,
    );
    if (notifiable) _n<void>(null, ok ? query : null);
    _db._log(ok ? 'done!' : 'failed!', action: 'set', field: id);
    return ok ? query : null;
  }

  Future<bool> delete({bool notifiable = false}) async {
    final ok = await _db._w(
      reference: reference,
      collectionPath: path,
      collectionId: id,
      documentId: id,
      type: InAppWriteType.collection,
    );
    if (notifiable) _n<void>(null, null);
    _db._log(ok ? 'done!' : 'failed!', action: 'delete', field: id);
    return ok;
  }

  Future<bool> drop({
    bool related = true,
    bool notifiable = false,
    Iterable<String> Function(String path, Iterable<String>)? filter,
  }) async {
    final ok = await _db._delete(path, related: related, filter: filter);
    if (notifiable) _n<void>(null, null);
    _db._log(ok ? 'done!' : 'failed!', action: 'drop', field: id);
    return ok;
  }

  Future<InAppQuerySnapshot> get() async {
    final result = await _db._r(
      reference: reference,
      collectionPath: path,
      collectionId: id,
      documentId: id,
      type: InAppReadType.collection,
    );
    return result is InAppQuerySnapshot ? result : InAppQuerySnapshot(id);
  }

  Stream<InAppQuerySnapshot> snapshots() {
    final n = _db._addNotifier(path);
    return Stream<InAppQuerySnapshot>.multi((controller) {
      void update() {
        if (controller.isClosed) return;
        controller.add(n.value ?? InAppQuerySnapshot(id));
      }

      n.addListener(update);
      controller.onCancel = () => n.removeListener(update);
      _notify();
    });
  }
}
