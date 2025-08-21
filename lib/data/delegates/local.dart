import 'package:data_management/core.dart';
import 'package:in_app_database/in_app_database.dart';

class LocalWriteBatch extends DataWriteBatch {
  late InAppWriteBatch batch;
  final InAppDatabase db;

  LocalWriteBatch(this.db);

  @override
  void init() {
    batch = db.batch();
  }

  @override
  Future<void> commit() async {
    await batch.commit();
  }

  @override
  void delete(String path) {
    batch.delete(db.doc(path));
  }

  @override
  void set(String path, Object data, [bool merge = true]) {
    batch.set(db.doc(path), data, InAppSetOptions(merge: merge));
  }

  @override
  void update(String path, Map<String, dynamic> data) {
    batch.update(db.doc(path), data);
  }
}

class LocalDataDelegate extends DataDelegate {
  final InAppDatabase _db;

  const LocalDataDelegate._(this._db);

  static LocalDataDelegate? _i;

  static LocalDataDelegate get i => instance;

  static LocalDataDelegate get instance {
    return _i ??= LocalDataDelegate._(InAppDatabase.instance);
  }

  @override
  DataWriteBatch batch() => LocalWriteBatch(_db);

  @override
  Future<int?> count(String path) {
    return _db.collection(path).count().get().then((snapshot) {
      return snapshot.count;
    });
  }

  @override
  Future<void> create(
    String path,
    Map<String, dynamic> data, [
    bool merge = true,
  ]) {
    return _db.doc(path).set(data, InAppSetOptions(merge: merge));
  }

  @override
  Future<void> delete(String path) {
    return _db.doc(path).delete();
  }

  @override
  Future<DataGetsSnapshot> get(String path) {
    return _db.collection(path).get().then((snapshot) {
      return DataGetsSnapshot(
        snapshot: snapshot,
        docs: snapshot.docs.map((e) => e.data).whereType(),
        docChanges: snapshot.docChanges.map((e) => e.doc.data).whereType(),
      );
    });
  }

  @override
  Future<DataGetSnapshot> getById(String path) {
    return _db.doc(path).get().then((snapshot) {
      return DataGetSnapshot(snapshot: snapshot, doc: snapshot.data);
    });
  }

  @override
  Future<DataGetsSnapshot> getByQuery(
    String path, {
    Iterable<DataQuery> queries = const [],
    Iterable<DataSelection> selections = const [],
    Iterable<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) {
    return LocalQueryHelper.query(
      _db.collection(path),
      queries: queries,
      selections: selections,
      sorts: sorts,
      options: options,
    ).get().then((snapshot) {
      return DataGetsSnapshot(
        snapshot: snapshot,
        docs: snapshot.docs.map((e) => e.data).whereType(),
        docChanges: snapshot.docChanges.map((e) => e.doc.data).whereType(),
      );
    });
  }

  @override
  Stream<DataGetsSnapshot> listen(String path) {
    return _db.collection(path).snapshots().map((snapshot) {
      return DataGetsSnapshot(
        snapshot: snapshot,
        docs: snapshot.docs.map((e) => e.data).whereType(),
        docChanges: snapshot.docChanges.map((e) => e.doc.data).whereType(),
      );
    });
  }

  @override
  Stream<DataGetSnapshot> listenById(String path) {
    return _db.doc(path).snapshots().map((snapshot) {
      return DataGetSnapshot(snapshot: snapshot, doc: snapshot.data);
    });
  }

  @override
  Stream<DataGetsSnapshot> listenByQuery(
    String path, {
    Iterable<DataQuery> queries = const [],
    Iterable<DataSelection> selections = const [],
    Iterable<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) {
    return LocalQueryHelper.query(
      _db.collection(path),
      queries: queries,
      selections: selections,
      sorts: sorts,
      options: options,
    ).snapshots().map((snapshot) {
      return DataGetsSnapshot(
        snapshot: snapshot,
        docs: snapshot.docs.map((e) => e.data).whereType(),
        docChanges: snapshot.docChanges.map((e) => e.doc.data).whereType(),
      );
    });
  }

  @override
  Future<DataGetsSnapshot> search(String path, Checker checker) {
    return LocalQueryHelper.search(_db.collection(path), checker).get().then((
      snapshot,
    ) {
      return DataGetsSnapshot(
        snapshot: snapshot,
        docs: snapshot.docs.map((e) => e.data).whereType(),
        docChanges: snapshot.docChanges.map((e) => e.doc.data).whereType(),
      );
    });
  }

  @override
  Future<void> update(String path, Map<String, dynamic> data) {
    return _db.doc(path).update(data);
  }

  @override
  Object? updatingFieldValue(Object? value) {
    if (value is! DataFieldValue) return value;
    switch (value.type) {
      case DataFieldValues.arrayUnion:
        return InAppFieldValue.arrayUnion(value.value as List);
      case DataFieldValues.arrayRemove:
        return InAppFieldValue.arrayRemove(value.value as List);
      case DataFieldValues.delete:
        return InAppFieldValue.delete();
      case DataFieldValues.serverTimestamp:
        return InAppFieldValue.timestamp();
      case DataFieldValues.increment:
        return InAppFieldValue.increment(value.value as num);
      case DataFieldValues.none:
        return value;
    }
  }
}

class LocalQueryHelper {
  const LocalQueryHelper._();

  static InAppQueryReference search(InAppQueryReference ref, Checker checker) {
    final field = checker.field;
    final value = checker.value;
    final type = checker.type;

    if (value is String) {
      if (type.isContains) {
        ref = ref.orderBy(field).startAt([value]).endAt(['$value\uf8ff']);
      } else {
        ref = ref.where(field, isEqualTo: value);
      }
    }

    return ref;
  }

  static InAppQueryReference query(
    InAppQueryReference ref, {
    Iterable<DataQuery> queries = const [],
    Iterable<DataSelection> selections = const [],
    Iterable<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) {
    var isFetchingMode = true;
    final fetchingSizeInit = options.initialSize ?? 0;
    final fetchingSize = options.fetchingSize ?? fetchingSizeInit;
    final isValidLimit = fetchingSize > 0;

    if (queries.isNotEmpty) {
      for (final i in queries) {
        ref = ref.where(
          i.field,
          arrayContains: i.arrayContains,
          arrayNotContains: i.arrayNotContains,
          arrayContainsAny: i.arrayContainsAny,
          arrayNotContainsAny: i.arrayNotContainsAny,
          isEqualTo: i.isEqualTo,
          isNotEqualTo: i.isNotEqualTo,
          isGreaterThan: i.isGreaterThan,
          isGreaterThanOrEqualTo: i.isGreaterThanOrEqualTo,
          isLessThan: i.isLessThan,
          isLessThanOrEqualTo: i.isLessThanOrEqualTo,
          isNull: i.isNull,
          whereIn: i.whereIn,
          whereNotIn: i.whereNotIn,
        );
      }
    }

    if (sorts.isNotEmpty) {
      for (final i in sorts) {
        ref = ref.orderBy(i.field, descending: i.descending);
      }
    }

    if (selections.isNotEmpty) {
      for (final i in selections) {
        final type = i.type;
        final value = i.value;
        final values = i.values;
        final isValidValues = values != null && values.isNotEmpty;
        final isValidSnapshot = value is InAppDocumentSnapshot;
        isFetchingMode = (isValidValues || isValidSnapshot) && !type.isNone;
        if (isValidValues) {
          if (type.isEndAt) {
            ref = ref.endAt(values);
          } else if (type.isEndBefore) {
            ref = ref.endBefore(values);
          } else if (type.isStartAfter) {
            ref = ref.startAfter(values);
          } else if (type.isStartAt) {
            ref = ref.startAt(values);
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
    }

    if (isValidLimit) {
      if (options.fetchFromLast) {
        if (isFetchingMode) {
          ref = ref.limitToLast(fetchingSize);
        } else {
          ref = ref.limitToLast(fetchingSizeInit);
        }
      } else {
        if (isFetchingMode) {
          ref = ref.limit(fetchingSize);
        } else {
          ref = ref.limit(fetchingSizeInit);
        }
      }
    }
    return ref;
  }
}
