import 'comparators.dart';
import 'exceptions.dart';
import 'field_path.dart';
import 'filter.dart';
import 'filter_engine.dart';
import 'sorting.dart';

typedef QueryDocument = Map<String, dynamic>;
typedef QueryDocuments = List<QueryDocument>;
typedef DocumentPredicate = bool Function(QueryDocument doc);
typedef DocumentTransformer = QueryDocument Function(QueryDocument doc);

sealed class QueryOp {
  const QueryOp();
}

final class FilterOp extends QueryOp {
  final DocumentPredicate predicate;

  const FilterOp(this.predicate);

  factory FilterOp.fromFilter(Filter filter) {
    return FilterOp((doc) => FilterEngine.matchesFilter(doc, filter));
  }

  factory FilterOp.fromConditions({
    required Object field,
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Object? arrayNotContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? arrayNotContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
  }) {
    final whereInSet = _toSet(whereIn);
    final whereNotInSet = _toSet(whereNotIn);
    final containsAnySet = _toSet(arrayContainsAny);
    final notContainsAnySet = _toSet(arrayNotContainsAny);

    return FilterOp((doc) {
      return FilterEngine.matchesConditions(
        doc,
        field: field,
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        arrayContains: arrayContains,
        arrayNotContains: arrayNotContains,
        arrayContainsAny: containsAnySet,
        arrayNotContainsAny: notContainsAnySet,
        whereInSet: whereInSet,
        whereNotInSet: whereNotInSet,
        isNull: isNull,
      );
    });
  }

  static Set<Object?>? _toSet(Iterable<Object?>? values) {
    if (values == null) return null;
    return values is Set<Object?> ? values : values.toSet();
  }
}

final class SortOp extends QueryOp {
  final List<Sorting> orders;

  const SortOp(this.orders);
}

final class CursorOp extends QueryOp {
  final List<Object?> values;
  final List<Sorting> orders;
  final bool inclusive;
  final bool isStart;

  const CursorOp({
    required this.values,
    required this.orders,
    required this.inclusive,
    required this.isStart,
  });

  bool matches(QueryDocument doc) {
    final cmp = _compareDoc(doc);
    if (isStart) return inclusive ? cmp >= 0 : cmp > 0;
    return inclusive ? cmp <= 0 : cmp < 0;
  }

  int _compareDoc(QueryDocument doc) {
    for (int i = 0; i < values.length; i++) {
      final sort = orders[i];
      final a = FieldPath.resolve(doc, sort.field);
      final b = values[i];
      if (a == null && b == null) continue;
      if (a == null) return sort.descending ? 1 : -1;
      if (b == null) return sort.descending ? -1 : 1;
      final cmp = Comparators.compare(a, b);
      if (cmp != 0) return sort.descending ? -cmp : cmp;
    }
    return 0;
  }
}

final class OffsetOp extends QueryOp {
  final int count;

  const OffsetOp(this.count);
}

final class LimitOp extends QueryOp {
  final int count;
  final bool toLast;

  const LimitOp(this.count, {this.toLast = false});
}

final class DistinctOp extends QueryOp {
  final Object? field;

  const DistinctOp([this.field]);
}

final class MapOp extends QueryOp {
  final DocumentTransformer transform;

  const MapOp(this.transform);
}

abstract final class QueryExecutor {
  const QueryExecutor._();

  static QueryDocuments execute(List<QueryDocument> source, List<QueryOp> ops) {
    if (ops.isEmpty) return source;

    final leadingFilters = <FilterOp>[];
    SortOp? sortOp;
    final cursors = <CursorOp>[];
    final tail = <QueryOp>[];

    var seenNonFilter = false;
    for (final op in ops) {
      if (op is FilterOp && !seenNonFilter) {
        leadingFilters.add(op);
        continue;
      }
      seenNonFilter = true;
      if (op is SortOp) {
        sortOp = op;
      } else if (op is CursorOp) {
        cursors.add(op);
      } else {
        tail.add(op);
      }
    }

    Iterable<QueryDocument> pipeline = source;

    if (leadingFilters.isNotEmpty) {
      pipeline = pipeline.where((doc) {
        for (var i = 0; i < leadingFilters.length; i++) {
          if (!leadingFilters[i].predicate(doc)) return false;
        }
        return true;
      });
    }

    QueryDocuments working;
    final activeSort = sortOp;

    if (activeSort != null) {
      working =
          pipeline is List<QueryDocument>
              ? List<QueryDocument>.of(pipeline)
              : pipeline.toList(growable: true);
      if (working.length > 1) _sortInPlace(working, activeSort.orders);
    } else {
      working =
          pipeline is List<QueryDocument>
              ? pipeline
              : pipeline.toList(growable: false);
    }

    if (cursors.isNotEmpty) {
      final filtered = <QueryDocument>[];
      for (final doc in working) {
        var keep = true;
        for (var i = 0; i < cursors.length; i++) {
          if (!cursors[i].matches(doc)) {
            keep = false;
            break;
          }
        }
        if (keep) filtered.add(doc);
      }
      working = filtered;
    }

    for (final op in tail) {
      working = _applyTail(working, op);
    }

    if (identical(working, source)) return source;
    return List<QueryDocument>.unmodifiable(working);
  }

  static QueryDocuments _applyTail(QueryDocuments data, QueryOp op) {
    switch (op) {
      case FilterOp(predicate: final p):
        final out = <QueryDocument>[];
        for (final doc in data) {
          if (p(doc)) out.add(doc);
        }
        return out;
      case OffsetOp(count: final c):
        if (c <= 0) return data;
        if (c >= data.length) return <QueryDocument>[];
        return data.sublist(c);
      case LimitOp(count: final c, toLast: final last):
        if (c >= data.length) return data;
        if (last) {
          final start = data.length - c;
          return start <= 0 ? data : data.sublist(start);
        }
        return data.sublist(0, c);
      case DistinctOp(field: final field):
        final seen = <Object?>{};
        final out = <QueryDocument>[];
        for (final doc in data) {
          final key =
              field == null
                  ? _stableMapHash(doc)
                  : FieldPath.resolve(doc, field);
          if (seen.add(key)) out.add(doc);
        }
        return out;
      case MapOp(transform: final t):
        final out = List<QueryDocument>.generate(
          data.length,
          (i) => t(data[i]),
          growable: false,
        );
        return out;
      case SortOp():
      case CursorOp():
        throw const InvalidQueryException(
          'Sort and cursor must be handled in main pipeline',
        );
    }
  }

  static void _sortInPlace(QueryDocuments data, List<Sorting> orders) {
    data.sort((a, b) {
      for (var i = 0; i < orders.length; i++) {
        final sort = orders[i];
        final x = FieldPath.resolve(a, sort.field);
        final y = FieldPath.resolve(b, sort.field);
        if (x == null && y == null) continue;
        if (x == null) return sort.descending ? -1 : 1;
        if (y == null) return sort.descending ? 1 : -1;
        final cmp = Comparators.compare(x, y);
        if (cmp != 0) return sort.descending ? -cmp : cmp;
      }
      return 0;
    });
  }

  static int _stableMapHash(Map map) {
    var hash = 0;
    for (final entry in map.entries) {
      hash ^= Object.hash(entry.key, entry.value);
    }
    return hash;
  }
}
