part of 'database.dart';

class InAppQueryReference extends InAppCollectionReference {
  final List<Query> _q;
  final List<Selection> _s;
  final List<Sorting> _o;
  final InAppPagingOptions _op;
  final bool _cm;

  const InAppQueryReference({
    required super.db,
    required super.reference,
    required super.path,
    required super.id,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    InAppPagingOptions options = const InAppPagingOptions(),
    bool counterMode = false,
  }) : _q = queries,
       _s = selections,
       _o = sorts,
       _op = options,
       _cm = counterMode;

  InAppQueryReference _copyWith({
    List<Query>? queries,
    List<Selection>? selections,
    List<Sorting>? sorts,
    InAppPagingOptions? options,
    bool? counterMode,
  }) {
    return InAppQueryReference(
      db: _db,
      reference: reference,
      path: path,
      id: id,
      queries: queries ?? _q,
      selections: selections ?? _s,
      sorts: sorts ?? _o,
      options: options ?? _op,
      counterMode: counterMode ?? _cm,
    );
  }

  InAppCounterReference count() {
    return InAppCounterReference(db: _db, reference: reference, parent: this);
  }

  InAppQueryReference _limit(int limit, [bool fetchFromLast = false]) {
    if (limit <= 0) {
      throw ArgumentError.value(limit, 'limit', 'must be > 0');
    }
    return _copyWith(
      options: _op.copy(
        initialSize: limit,
        fetchingSize: limit,
        fetchFromLast: fetchFromLast,
      ),
    );
  }

  InAppQueryReference limit(int limit) => _limit(limit);

  InAppQueryReference limitToLast(int limit) => _limit(limit, true);

  InAppQueryReference orderBy(Object field, {bool descending = false}) {
    if (field is! String || field.isEmpty) return this;
    final sorts = List<Sorting>.of(_o)
      ..add(Sorting(field, descending: descending));
    return _copyWith(sorts: sorts);
  }

  InAppQueryReference _selection(Object? snapshot, Selections type) {
    if (snapshot is! InAppDocument && snapshot is! Iterable<InAppValue>) {
      return this;
    }
    final selections = List<Selection>.of(_s)
      ..add(Selection.from(snapshot, type));
    return _copyWith(selections: selections);
  }

  InAppQueryReference where(
    Object field, {
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
    final queries = List<Query>.of(_q)..add(
      Query(
        field,
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        arrayContains: arrayContains,
        arrayNotContains: arrayNotContains,
        arrayContainsAny: arrayContainsAny,
        arrayNotContainsAny: arrayNotContainsAny,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
        isNull: isNull,
      ),
    );
    return _copyWith(queries: queries);
  }

  InAppQueryReference endAtDocument(InAppValue? snapshot) =>
      _selection(snapshot, Selections.endAtDocument);

  InAppQueryReference endAt(Iterable<InAppValue>? values) =>
      _selection(values, Selections.endAt);

  InAppQueryReference endBeforeDocument(InAppValue? snapshot) =>
      _selection(snapshot, Selections.endBeforeDocument);

  InAppQueryReference endBefore(Iterable<InAppValue>? values) =>
      _selection(values, Selections.endBefore);

  InAppQueryReference startAfterDocument(InAppValue? snapshot) =>
      _selection(snapshot, Selections.startAfterDocument);

  InAppQueryReference startAfter(Iterable<InAppValue>? values) =>
      _selection(values, Selections.startAfter);

  InAppQueryReference startAtDocument(InAppValue? snapshot) =>
      _selection(snapshot, Selections.startAtDocument);

  InAppQueryReference startAt(Iterable<InAppValue>? values) =>
      _selection(values, Selections.startAt);

  bool get _hasPipeline =>
      _q.isNotEmpty || _o.isNotEmpty || _s.isNotEmpty || _op.hasLimit;

  @override
  Future<InAppQuerySnapshot> get() async {
    if (!_hasPipeline) return super.get();

    final raw = await super.get();
    final data = raw.docs
        .map((e) => e.data ?? const <String, InAppValue>{})
        .toList(growable: false);

    QueryBuilder builder = QueryBuilder(data);

    for (final q in _q) {
      builder = builder.where(
        q.field,
        isEqualTo: q.isEqualTo,
        isNotEqualTo: q.isNotEqualTo,
        isNull: q.isNull,
        isGreaterThan: q.isGreaterThan,
        isGreaterThanOrEqualTo: q.isGreaterThanOrEqualTo,
        isLessThan: q.isLessThan,
        isLessThanOrEqualTo: q.isLessThanOrEqualTo,
        whereIn: q.whereIn,
        whereNotIn: q.whereNotIn,
        arrayContains: q.arrayContains,
        arrayNotContains: q.arrayNotContains,
        arrayContainsAny: q.arrayContainsAny,
        arrayNotContainsAny: q.arrayNotContainsAny,
      );
    }

    for (final s in _o) {
      builder = builder.orderBy(s.field, descending: s.descending);
    }

    for (final sel in _s) {
      final v = sel.value;
      final vs = sel.values;
      if (v is! Map<String, dynamic> && vs is! Iterable<Object?>) continue;
      final mapValue =
          v is Map<String, dynamic> ? v : const <String, dynamic>{};
      final listValues = vs == null ? const <Object?>[] : List<Object?>.of(vs);
      switch (sel.type) {
        case Selections.endAt:
          builder = builder.endAt(listValues);
          break;
        case Selections.endAtDocument:
          builder = builder.endAtDocument(mapValue);
          break;
        case Selections.endBefore:
          builder = builder.endBefore(listValues);
          break;
        case Selections.endBeforeDocument:
          builder = builder.endBeforeDocument(mapValue);
          break;
        case Selections.startAfter:
          builder = builder.startAfter(listValues);
          break;
        case Selections.startAfterDocument:
          builder = builder.startAfterDocument(mapValue);
          break;
        case Selections.startAt:
          builder = builder.startAt(listValues);
          break;
        case Selections.startAtDocument:
          builder = builder.startAtDocument(mapValue);
          break;
        case Selections.none:
          break;
      }
    }

    if (_op.hasLimit) {
      final size = _op.fetchingSize!;
      builder =
          _op.fetchFromLast ? builder.limitToLast(size) : builder.limit(size);
    }

    final processed = await builder.execute();
    final docs = <InAppDocumentSnapshot>[];
    for (final e in processed) {
      final i = e[_idField] ?? e[_idFieldSecondary];
      final docId = i is String && i.isNotEmpty ? i : _id;
      docs.add(InAppDocumentSnapshot(docId, e));
    }
    return InAppQuerySnapshot(raw.id, docs);
  }

  @override
  Stream<InAppQuerySnapshot> snapshots() {
    final n = _db._addNotifier(path);
    return Stream<InAppQuerySnapshot>.multi((controller) {
      void update() {
        if (controller.isClosed) return;
        get()
            .then((s) {
              if (!controller.isClosed) controller.add(s);
            })
            .catchError((_) {});
      }

      n.addListener(update);
      controller.onCancel = () => n.removeListener(update);
      _notify();
    });
  }
}
