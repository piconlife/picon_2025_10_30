import 'dart:async' show StreamController, StreamSubscription;

import '../../app/imports/cloud_firestore.dart'
    show
        AggregateQuerySnapshot,
        DocumentSnapshot,
        FieldPath,
        FieldValue,
        FirebaseFirestore,
        Query,
        QuerySnapshot,
        SetOptions,
        WriteBatch;
import '../../app/imports/data_management.dart'
    show
        Checker,
        DataAggregateSnapshot,
        DataDelegate,
        DataFetchOptions,
        DataFieldPath,
        DataFieldPaths,
        DataFieldValue,
        DataFieldValues,
        DataGetSnapshot,
        DataGetsSnapshot,
        DataQuery,
        DataSelection,
        DataSorting,
        DataWriteBatch;

class FirestoreWriteBatch extends DataWriteBatch {
  late final WriteBatch _batch;
  final FirebaseFirestore db;

  FirestoreWriteBatch(this.db) {
    _batch = db.batch();
  }

  @override
  void onDelete(String path) => _batch.delete(db.doc(path));

  @override
  void onSet(String path, Object data, {bool merge = true}) {
    _batch.set(db.doc(path), data, SetOptions(merge: merge));
  }

  @override
  void onUpdate(String path, Map<String, dynamic> data) {
    _batch.update(db.doc(path), data);
  }

  @override
  Future<void> onCommit() => _batch.commit();
}

class FirestoreDataDelegate extends DataDelegate {
  final FirebaseFirestore _db;
  final Duration operationTimeout;
  final Duration countInterval;

  final Map<String, _MulticastStream<DataGetsSnapshot>> _listenCache = {};
  final Map<String, _MulticastStream<DataGetSnapshot>> _docCache = {};
  final Map<String, _MulticastStream<DataAggregateSnapshot>> _countCache = {};

  FirestoreDataDelegate({
    FirebaseFirestore? firestore,
    this.operationTimeout = const Duration(seconds: 15),
    this.countInterval = const Duration(seconds: 30),
  }) : _db = firestore ?? FirebaseFirestore.instance;

  static FirestoreDataDelegate? _i;

  static FirestoreDataDelegate get i => instance;

  static FirestoreDataDelegate get instance => _i ??= FirestoreDataDelegate();

  Future<void> dispose() async {
    final all = <_MulticastStream<dynamic>>[
      ..._listenCache.values,
      ..._docCache.values,
      ..._countCache.values,
    ];
    _listenCache.clear();
    _docCache.clear();
    _countCache.clear();
    await Future.wait(all.map((e) => e.dispose()));
    if (identical(_i, this)) _i = null;
  }

  Map<String, dynamic> _withId(String id, Object? data) {
    if (data == null || data is! Map) return <String, dynamic>{'id': id};
    return <String, dynamic>{
      ...data.map((k, v) => MapEntry(k.toString(), v)),
      'id': id,
    };
  }

  DataAggregateSnapshot _agg(AggregateQuerySnapshot snapshot) {
    return DataAggregateSnapshot(count: snapshot.count, snapshot: snapshot);
  }

  DataGetSnapshot _doc(DocumentSnapshot snapshot) {
    return DataGetSnapshot(
      doc: _withId(snapshot.id, snapshot.data()),
      snapshot: snapshot,
    );
  }

  DataGetsSnapshot _docs(QuerySnapshot snapshot) {
    final docs = snapshot.docs
        .map((e) => _withId(e.id, e.data()))
        .toList(growable: false);
    final docChanges = snapshot.docChanges
        .map((e) => _withId(e.doc.id, e.doc.data()))
        .toList(growable: false);
    return DataGetsSnapshot(
      docs: docs,
      docChanges: docChanges,
      snapshot: snapshot,
    );
  }

  Stream<T> _multicast<T>(
    Map<String, _MulticastStream<T>> cache,
    String key,
    Stream<T> Function() factory,
  ) {
    final existing = cache[key];
    if (existing != null && !existing.isClosed) return existing.subscribe();
    late _MulticastStream<T> entry;
    entry = _MulticastStream<T>(factory, () {
      if (identical(cache[key], entry)) cache.remove(key);
    });
    cache[key] = entry;
    return entry.subscribe();
  }

  Future<DataAggregateSnapshot> _safeCount(String path) async {
    try {
      final snap = await _db
          .collection(path)
          .count()
          .get()
          .timeout(operationTimeout);
      return _agg(snap);
    } catch (_) {
      return const DataAggregateSnapshot();
    }
  }

  Stream<DataAggregateSnapshot> _countStream(String path) async* {
    yield await _safeCount(path);
    yield* Stream.periodic(countInterval).asyncMap((_) => _safeCount(path));
  }

  @override
  DataWriteBatch batch() => FirestoreWriteBatch(_db);

  @override
  Future<int?> count(String path) async {
    final snapshot = await _db
        .collection(path)
        .count()
        .get()
        .timeout(operationTimeout);
    return snapshot.count;
  }

  @override
  Future<void> create(
    String path,
    Map<String, dynamic> data, [
    bool merge = true,
  ]) {
    return _db
        .doc(path)
        .set(data, SetOptions(merge: merge))
        .timeout(operationTimeout);
  }

  @override
  Future<void> delete(String path) {
    return _db.doc(path).delete().timeout(operationTimeout);
  }

  @override
  Future<DataGetsSnapshot> get(String path) async {
    final snapshot = await _db.collection(path).get().timeout(operationTimeout);
    return _docs(snapshot);
  }

  @override
  Future<DataGetSnapshot> getById(String path) async {
    final snapshot = await _db.doc(path).get().timeout(operationTimeout);
    return _doc(snapshot);
  }

  @override
  Future<DataGetsSnapshot> getByQuery(
    String path, {
    Iterable<DataQuery> queries = const [],
    Iterable<DataSelection> selections = const [],
    Iterable<DataSorting> sorts = const [],
    DataFetchOptions options = const DataFetchOptions(),
  }) async {
    final snapshot = await FirestoreQueryHelper.query(
      _db.collection(path),
      queries: queries,
      selections: selections,
      sorts: sorts,
      options: options,
    ).get().timeout(operationTimeout);
    return _docs(snapshot);
  }

  @override
  Stream<DataGetsSnapshot> listen(String path) {
    return _multicast(
      _listenCache,
      path,
      () => _db.collection(path).snapshots().map(_docs),
    );
  }

  @override
  Stream<DataAggregateSnapshot> listenCount(String path) {
    return _multicast(_countCache, path, () => _countStream(path));
  }

  @override
  Stream<DataGetSnapshot> listenById(String path) {
    return _multicast(
      _docCache,
      path,
      () => _db.doc(path).snapshots().map(_doc),
    );
  }

  @override
  Stream<DataGetsSnapshot> listenByQuery(
    String path, {
    Iterable<DataQuery> queries = const [],
    Iterable<DataSelection> selections = const [],
    Iterable<DataSorting> sorts = const [],
    DataFetchOptions options = const DataFetchOptions(),
  }) {
    return FirestoreQueryHelper.query(
      _db.collection(path),
      queries: queries,
      selections: selections,
      sorts: sorts,
      options: options,
    ).snapshots().map(_docs);
  }

  @override
  Future<DataGetsSnapshot> search(String path, Checker checker) async {
    final snapshot = await FirestoreQueryHelper.search(
      _db.collection(path),
      checker,
    ).get().timeout(operationTimeout);
    return _docs(snapshot);
  }

  @override
  Future<void> update(String path, Map<String, dynamic> data) {
    return _db.doc(path).update(data).timeout(operationTimeout);
  }

  @override
  Object resolveFieldPath(Object field, String documentId) {
    if (field is! DataFieldPath) return field;
    return switch (field.type) {
      DataFieldPaths.documentId => FieldPath.documentId,
      DataFieldPaths.none => field,
    };
  }

  @override
  Object? resolveFieldValue(Object? value) {
    if (value is! DataFieldValue) return value;
    switch (value.type) {
      case DataFieldValues.arrayUnion:
        final list = value.value;
        return list is List ? FieldValue.arrayUnion(list) : value;
      case DataFieldValues.arrayRemove:
        final list = value.value;
        return list is List ? FieldValue.arrayRemove(list) : value;
      case DataFieldValues.delete:
        return FieldValue.delete();
      case DataFieldValues.serverTimestamp:
        return FieldValue.serverTimestamp();
      case DataFieldValues.increment:
        final n = value.value;
        return n is num ? FieldValue.increment(n) : value;
      case DataFieldValues.none:
        return value;
    }
  }
}

class FirestoreQueryHelper {
  const FirestoreQueryHelper._();

  static Query<T> search<T extends Object?>(Query<T> ref, Checker checker) {
    final field = checker.field;
    final value = checker.value;
    final type = checker.type;

    if (field.isEmpty) return ref;

    if (value is String && value.isNotEmpty) {
      if (type.isContains) {
        return ref.orderBy(field).startAt([value]).endAt(['$value\uf8ff']);
      }
      return ref.where(field, isEqualTo: value);
    }

    if (value != null) {
      return ref.where(field, isEqualTo: value);
    }

    return ref;
  }

  static Query<T> query<T extends Object?>(
    Query<T> ref, {
    Iterable<DataQuery> queries = const [],
    Iterable<DataSelection> selections = const [],
    Iterable<DataSorting> sorts = const [],
    DataFetchOptions options = const DataFetchOptions(),
  }) {
    var isFetchingMode = true;
    final fetchingSizeInit = options.initialSize ?? 0;
    final fetchingSize = options.fetchingSize ?? fetchingSizeInit;
    final isValidLimit = fetchingSize > 0;

    for (final i in queries) {
      ref = ref.where(
        i.field,
        arrayContains: i.arrayContains,
        arrayContainsAny: i.arrayContainsAny?.toList(),
        isEqualTo: i.isEqualTo,
        isNotEqualTo: i.isNotEqualTo,
        isGreaterThan: i.isGreaterThan,
        isGreaterThanOrEqualTo: i.isGreaterThanOrEqualTo,
        isLessThan: i.isLessThan,
        isLessThanOrEqualTo: i.isLessThanOrEqualTo,
        isNull: i.isNull,
        whereIn: i.whereIn?.toList(),
        whereNotIn: i.whereNotIn?.toList(),
      );
    }

    for (final i in sorts) {
      ref = ref.orderBy(i.field, descending: i.descending);
    }

    for (final i in selections) {
      final type = i.type;
      final value = i.value;
      final values = i.values;
      final isValidValues = values != null && values.isNotEmpty;
      final isValidSnapshot = value is DocumentSnapshot;
      isFetchingMode = (isValidValues || isValidSnapshot) && !type.isNone;
      if (isValidValues) {
        final list = values.toList();
        if (type.isEndAt) {
          ref = ref.endAt(list);
        } else if (type.isEndBefore) {
          ref = ref.endBefore(list);
        } else if (type.isStartAfter) {
          ref = ref.startAfter(list);
        } else if (type.isStartAt) {
          ref = ref.startAt(list);
        }
      } else if (isValidSnapshot) {
        if (type.isEndAtDocument) {
          ref = ref.endAtDocument(value);
        } else if (type.isEndBeforeDocument) {
          ref = ref.endBeforeDocument(value);
        } else if (type.isStartAfterDocument) {
          ref = ref.startAfterDocument(value);
        } else if (type.isStartAtDocument) {
          ref = ref.startAtDocument(value);
        }
      }
    }

    if (isValidLimit) {
      final size = isFetchingMode ? fetchingSize : fetchingSizeInit;
      if (size > 0) {
        ref = options.fetchFromLast ? ref.limitToLast(size) : ref.limit(size);
      }
    }
    return ref;
  }
}

class _MulticastStream<T> {
  final Stream<T> Function() _factory;
  final void Function() _onTearDown;
  final StreamController<T> _broadcast = StreamController<T>.broadcast();

  StreamSubscription<T>? _upstream;
  T? _last;
  bool _hasLast = false;
  bool _disposed = false;

  _MulticastStream(this._factory, this._onTearDown);

  bool get isClosed => _disposed || _broadcast.isClosed;

  Stream<T> subscribe() {
    late StreamController<T> view;
    StreamSubscription<T>? sub;

    view = StreamController<T>(
      onListen: () {
        _ensureUpstream();
        if (_hasLast && !view.isClosed) view.add(_last as T);
        sub = _broadcast.stream.listen(
          (event) {
            if (!view.isClosed) view.add(event);
          },
          onError: (Object e, StackTrace s) {
            if (!view.isClosed) view.addError(e, s);
          },
          onDone: () {
            if (!view.isClosed) view.close();
          },
        );
      },
      onCancel: () async {
        await sub?.cancel();
        sub = null;
        _maybeTearDown();
      },
    );

    return view.stream;
  }

  void _ensureUpstream() {
    if (_upstream != null || _disposed) return;
    _upstream = _factory().listen(
      (event) {
        _last = event;
        _hasLast = true;
        if (!_broadcast.isClosed) _broadcast.add(event);
      },
      onError: (Object e, StackTrace s) {
        if (!_broadcast.isClosed) _broadcast.addError(e, s);
      },
      onDone: () {
        if (!_broadcast.isClosed) _broadcast.close();
      },
    );
  }

  void _maybeTearDown() {
    if (_broadcast.hasListener || _disposed) return;
    _disposed = true;
    _upstream?.cancel();
    _upstream = null;
    if (!_broadcast.isClosed) _broadcast.close();
    _onTearDown();
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    await _upstream?.cancel();
    _upstream = null;
    if (!_broadcast.isClosed) await _broadcast.close();
  }
}
