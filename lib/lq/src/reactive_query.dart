import 'dart:async';

import 'builder.dart';

class ReactiveQuery {
  final Collection _collection;
  final QueryBuilder Function(QueryBuilder builder) _build;

  const ReactiveQuery._(this._collection, this._build);

  factory ReactiveQuery({
    required Collection source,
    required QueryBuilder Function(QueryBuilder builder) query,
  }) => ReactiveQuery._(source, query);

  Stream<QueryDocuments> watch() async* {
    yield _execute();
    await for (final _ in _collection.changes) {
      yield _execute();
    }
  }

  Stream<QueryDocument?> watchFirst() async* {
    await for (final batch in watch()) {
      yield batch.isEmpty ? null : batch.first;
    }
  }

  Stream<int> watchCount() async* {
    await for (final batch in watch()) {
      yield batch.length;
    }
  }

  QueryDocuments now() => _execute();

  QueryDocuments _execute() {
    return _build(QueryBuilder(_collection.documents)).build();
  }
}
