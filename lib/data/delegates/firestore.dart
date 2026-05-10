import '../../app/imports/cloud_firestore.dart'
    show
        WriteBatch,
        SetOptions,
        FirebaseFirestore,
        Query,
        DocumentSnapshot,
        FieldValue,
        FieldPath;
import '../../app/imports/data_management.dart'
    show
        DataWriteBatch,
        DataDelegate,
        DataGetsSnapshot,
        DataGetSnapshot,
        DataQuery,
        DataSelection,
        DataSorting,
        DataFetchOptions,
        Checker,
        DataFieldValue,
        DataFieldValues,
        DataFieldPath,
        DataFieldPaths,
        DataAggregateSnapshot;

class FirestoreWriteBatch extends DataWriteBatch {
  late final WriteBatch _batch;
  final FirebaseFirestore db;

  FirestoreWriteBatch(this.db) {
    _batch = db.batch();
  }

  @override
  void onDelete(String path) {
    _batch.delete(db.doc(path));
  }

  @override
  void onSet(String path, Object data, {bool merge = true}) {
    _batch.set(db.doc(path), data, SetOptions(merge: merge));
  }

  @override
  void onUpdate(String path, Map<String, dynamic> data) {
    _batch.update(db.doc(path), data);
  }

  @override
  Future<void> onCommit() async {
    await _batch.commit();
  }
}

class FirestoreDataDelegate extends DataDelegate {
  final FirebaseFirestore _db;

  const FirestoreDataDelegate._(this._db);

  static FirestoreDataDelegate? _i;

  static FirestoreDataDelegate get i => instance;

  static FirestoreDataDelegate get instance {
    return _i ??= FirestoreDataDelegate._(FirebaseFirestore.instance);
  }

  @override
  DataWriteBatch batch() => FirestoreWriteBatch(_db);

  @override
  Future<int?> count(String path) async {
    final snapshot = await _db.collection(path).count().get();
    return snapshot.count;
  }

  @override
  Future<void> create(
    String path,
    Map<String, dynamic> data, [
    bool merge = true,
  ]) {
    return _db.doc(path).set(data, SetOptions(merge: merge));
  }

  @override
  Future<void> delete(String path) {
    return _db.doc(path).delete();
  }

  @override
  Future<DataGetsSnapshot> get(String path) async {
    final snapshot = await _db.collection(path).get();
    return DataGetsSnapshot(
      snapshot: snapshot,
      docs: snapshot.docs.map((e) => e.data()).toList(growable: false),
      docChanges: snapshot.docChanges
          .map((e) => e.doc.data())
          .whereType<Map<String, dynamic>>()
          .toList(growable: false),
    );
  }

  @override
  Future<DataGetSnapshot> getById(String path) async {
    final snapshot = await _db.doc(path).get();
    return DataGetSnapshot(snapshot: snapshot, doc: snapshot.data());
  }

  @override
  Future<DataGetsSnapshot> getByQuery(
    String path, {
    Iterable<DataQuery> queries = const [],
    Iterable<DataSelection> selections = const [],
    Iterable<DataSorting> sorts = const [],
    DataFetchOptions options = const DataFetchOptions(),
  }) async {
    final snapshot =
        await FirestoreQueryHelper.query(
          _db.collection(path),
          queries: queries,
          selections: selections,
          sorts: sorts,
          options: options,
        ).get();
    return DataGetsSnapshot(
      snapshot: snapshot,
      docs: snapshot.docs.map((e) => e.data()).toList(growable: false),
      docChanges: snapshot.docChanges
          .map((e) => e.doc.data())
          .whereType<Map<String, dynamic>>()
          .toList(growable: false),
    );
  }

  @override
  Stream<DataGetsSnapshot> listen(String path) {
    return _db.collection(path).snapshots().map((snapshot) {
      return DataGetsSnapshot(
        snapshot: snapshot,
        docs: snapshot.docs.map((e) => e.data()).toList(growable: false),
        docChanges: snapshot.docChanges
            .map((e) => e.doc.data())
            .whereType<Map<String, dynamic>>()
            .toList(growable: false),
      );
    });
  }

  @override
  Stream<DataAggregateSnapshot> listenCount(String path) {
    return Stream.periodic(Duration(seconds: 10)).asyncMap((_) {
      return _db.collection(path).count().get().then((snapshot) {
        return DataAggregateSnapshot(snapshot: snapshot, count: snapshot.count);
      });
    });
  }

  @override
  Stream<DataGetSnapshot> listenById(String path) {
    return _db.doc(path).snapshots().map((snapshot) {
      return DataGetSnapshot(snapshot: snapshot, doc: snapshot.data());
    });
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
    ).snapshots().map((snapshot) {
      return DataGetsSnapshot(
        snapshot: snapshot,
        docs: snapshot.docs.map((e) => e.data()).toList(growable: false),
        docChanges: snapshot.docChanges
            .map((e) => e.doc.data())
            .whereType<Map<String, dynamic>>()
            .toList(growable: false),
      );
    });
  }

  @override
  Future<DataGetsSnapshot> search(String path, Checker checker) async {
    final snapshot =
        await FirestoreQueryHelper.search(_db.collection(path), checker).get();
    return DataGetsSnapshot(
      snapshot: snapshot,
      docs: snapshot.docs.map((e) => e.data()).toList(growable: false),
      docChanges: snapshot.docChanges
          .map((e) => e.doc.data())
          .whereType<Map<String, dynamic>>()
          .toList(growable: false),
    );
  }

  @override
  Future<void> update(String path, Map<String, dynamic> data) {
    return _db.doc(path).update(data);
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

    if (value is String && value.isNotEmpty) {
      if (type.isContains) {
        ref = ref.orderBy(field).startAt([value]).endAt(['$value\uf8ff']);
      } else {
        ref = ref.where(field, isEqualTo: value);
      }
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
