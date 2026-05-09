part of 'database.dart';

class InAppDocumentReference extends InAppReference {
  final String id;
  final InAppCollectionReference _p;

  const InAppDocumentReference({
    required super.reference,
    required super.db,
    required this.id,
    required InAppCollectionReference parent,
  }) : _p = parent;

  String get path => '${_p.path}/$id';

  InAppCollectionReference get parent => _p;

  InAppQueryNotifier? get _cn {
    final n = _db._notifiers[_p.path];
    return n is InAppQueryNotifier ? n : null;
  }

  InAppDocumentNotifier? get _dn => _cn?.children[id];

  T _n<T>(T value, [InAppDocumentSnapshot? snapshot]) {
    final cn = _cn;
    if (cn != null && !cn.isDisposed) _p._notify();
    final dn = _dn;
    if (dn != null && !dn.isDisposed) {
      if (snapshot == null) {
        get()
            .then((s) {
              if (!dn.isDisposed) dn.value = s;
            })
            .catchError((_) {});
      } else {
        dn.value = snapshot;
      }
    }
    return value;
  }

  void _notify([InAppDocumentSnapshot? snapshot]) => _n<void>(null, snapshot);

  InAppQueryReference collection(String field) {
    if (field.isEmpty) {
      throw ArgumentError.value(
        field,
        'field',
        'Collection id cannot be empty.',
      );
    }
    if (field.contains('/')) {
      throw ArgumentError.value(
        field,
        'field',
        'Collection id cannot contain "/".',
      );
    }
    return InAppQueryReference(
      db: _db,
      reference: '$reference/$field',
      path: '$path/$field',
      id: field,
    );
  }

  Future<InAppDocumentSnapshot?> set(
    InAppDocument data, [
    InAppSetOptions options = InAppSetOptions.defaults,
  ]) async {
    final raw = data[_idField];
    final mId = raw is String && raw.isNotEmpty ? raw : id;
    final payload = Map<String, InAppValue>.of(data);
    payload[_idField] = mId;

    if (options.merge) {
      return update(payload);
    }

    final ok = await _db._w(
      reference: reference,
      collectionPath: _p.path,
      collectionId: _p.id,
      documentId: mId,
      type: InAppWriteType.document,
      value: payload,
    );
    final snap = ok ? InAppDocumentSnapshot(mId, payload) : null;
    _n<void>(null, snap);
    _db._log(ok ? 'done!' : 'failed!', action: 'set', field: id);
    return snap;
  }

  Future<InAppDocumentSnapshot?> update(InAppDocument data) async {
    final base = await get();
    final merged = InAppMerger(base.data).merge(data);
    merged[_idField] = id;
    final ok = await _db._w(
      reference: reference,
      collectionPath: _p.path,
      collectionId: _p.id,
      documentId: id,
      type: InAppWriteType.document,
      value: merged,
    );
    final snap = ok ? InAppDocumentSnapshot(id, merged) : null;
    _n<void>(null, snap);
    _db._log(ok ? 'done!' : 'failed!', action: 'update', field: id);
    return snap;
  }

  Future<bool> delete() async {
    final ok = await _db._w(
      reference: reference,
      collectionPath: _p.path,
      collectionId: _p.id,
      documentId: id,
      type: InAppWriteType.document,
    );
    if (ok) {
      final remaining = await _p.get();
      if (!remaining.exists) {
        await _db._w(
          type: InAppWriteType.collection,
          reference: _p.reference,
          collectionPath: _p.path,
          collectionId: _p.id,
          documentId: _p.id,
        );
      }
    }
    _n<void>(null, null);
    _db._log(ok ? 'done!' : 'failed!', action: 'delete', field: id);
    return ok;
  }

  Future<InAppDocumentSnapshot> get() async {
    final result = await _db._r(
      reference: reference,
      collectionPath: _p.path,
      collectionId: _p.id,
      documentId: id,
      type: InAppReadType.document,
    );
    return result is InAppDocumentSnapshot ? result : InAppDocumentSnapshot(id);
  }

  Stream<InAppDocumentSnapshot> snapshots() {
    final n = _db._addChildNotifier(_p.path, id);
    return Stream<InAppDocumentSnapshot>.multi((controller) {
      void update() {
        if (controller.isClosed) return;
        controller.add(n.value ?? InAppDocumentSnapshot(id));
      }

      n.addListener(update);
      controller.onCancel = () => n.removeListener(update);
      _notify();
    });
  }
}
