part of 'base.dart';

mixin _SourceListenMixin<T extends Entity>
    on _SourceExecuteMixin<T>, _SourceEncryptionMixin<T>, _SourcePathMixin<T> {
  DataDelegate get delegate;

  DataOperation get operation;

  DataLimitations get limitations;

  T build(dynamic source);

  Stream<Response<T>> listen({
    DataFieldParams? params,
    bool? countable,
    bool onlyUpdates = false,
    bool resolveRefs = false,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
  }) {
    return executeStream(() {
      final p = ref(params, DataModifiers.listen);
      return operation
          .listen(
            p,
            countable: countable ?? false,
            resolveRefs: resolveRefs && !onlyUpdates,
            resolveDocChangesRefs:
                resolveDocChangesRefs || (onlyUpdates && resolveRefs),
            ignore: ignore,
          )
          .asyncMap((event) async {
            final docs = onlyUpdates ? event.docChanges : event.docs;
            if (docs.isEmpty) {
              return Response(
                status: Status.notFound,
                snapshot: event.snapshot,
              );
            }
            final result = await _buildAll(docs);
            if (result.isEmpty) {
              return Response(
                status: Status.notFound,
                snapshot: event.snapshot,
              );
            }
            return Response(
              result: result,
              snapshot: event.snapshot,
              status: Status.ok,
            );
          });
    });
  }

  Stream<Response<T>> listenById(
    String id, {
    DataFieldParams? params,
    bool? countable,
    bool resolveRefs = false,
    Ignore? ignore,
  }) {
    if (id.isEmpty) return Stream.value(Response(status: Status.invalidId));
    return executeStream(() {
      final p = ref(params, DataModifiers.listenById, id);
      return operation
          .listenById(
            p,
            countable: countable ?? false,
            resolveRefs: resolveRefs,
            ignore: ignore,
          )
          .asyncMap((event) async {
            if (!event.exists) return Response(status: Status.notFound);
            final v = await decryptDoc(event.doc);
            return Response(status: Status.ok, data: build(v), snapshot: event);
          });
    });
  }

  Stream<Response<T>> listenByIds(
    Iterable<String> ids, {
    DataFieldParams? params,
    bool? countable,
    bool resolveRefs = false,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
  }) {
    if (ids.isEmpty) return Stream.value(Response(status: Status.invalid));
    return executeStream(() {
      if (limitations.whereIn > 0 && ids.length > limitations.whereIn) {
        final map = <String, T>{};
        return StreamGroup.merge(
          ids.map(
            (e) => listenById(
              e,
              countable: countable,
              params: params,
              resolveRefs: resolveRefs,
              ignore: ignore,
            ),
          ),
        ).map((event) {
          final data = event.data;
          if (data != null) map[data.id] = data;
          if (map.isEmpty) return Response(status: Status.notFound);
          return Response(
            result: map.values.toList(),
            snapshot: event.snapshot,
            status: Status.ok,
          );
        });
      }
      final p = ref(params, DataModifiers.listenByIds);
      return operation
          .listenByQuery(
            p,
            countable: countable ?? false,
            resolveRefs: resolveRefs,
            resolveDocChangesRefs: resolveDocChangesRefs,
            ignore: ignore,
            queries: [DataQuery(DataFieldPath.documentId, whereIn: ids)],
          )
          .asyncMap((event) async {
            if (event.docs.isEmpty) {
              return Response(
                status: Status.notFound,
                snapshot: event.snapshot,
              );
            }
            final result = await _buildAll(event.docs);
            if (result.isEmpty) {
              return Response(
                status: Status.notFound,
                snapshot: event.snapshot,
              );
            }
            return Response(
              status: Status.ok,
              result: result,
              snapshot: event.snapshot,
            );
          });
    });
  }

  Stream<Response<T>> listenByQuery({
    DataFieldParams? params,
    Iterable<DataQuery> queries = const [],
    Iterable<DataSelection> selections = const [],
    Iterable<DataSorting> sorts = const [],
    DataFetchOptions options = const DataFetchOptions(),
    bool? countable,
    bool onlyUpdates = false,
    bool resolveRefs = false,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
  }) {
    return executeStream(() {
      final p = ref(params, DataModifiers.listenByQuery);
      final adjustedQueries = queries.map(
        (e) => e.adjust(delegate.queryFieldValue),
      );
      final adjustedSelections = selections.map(
        (e) => e.adjust(delegate.queryFieldValue),
      );
      return operation
          .listenByQuery(
            p,
            queries: adjustedQueries,
            selections: adjustedSelections,
            sorts: sorts,
            options: options,
            countable: countable ?? false,
            resolveRefs: resolveRefs && !onlyUpdates,
            resolveDocChangesRefs:
                resolveDocChangesRefs || (onlyUpdates && resolveRefs),
            ignore: ignore,
          )
          .asyncMap((event) async {
            final docs = onlyUpdates ? event.docChanges : event.docs;
            if (docs.isEmpty) {
              return Response(
                status: Status.notFound,
                snapshot: event.snapshot,
              );
            }
            final result = await _buildAll(docs);
            if (result.isEmpty) {
              return Response(
                status: Status.notFound,
                snapshot: event.snapshot,
              );
            }
            return Response(
              result: result,
              snapshot: event.snapshot,
              status: Status.ok,
            );
          });
    });
  }

  Stream<Response<int>> listenCount({
    DataFieldParams? params,
    Duration? interval,
  }) {
    return executeStream(() {
      final p = ref(params, DataModifiers.listenCount);
      return Stream.periodic(interval ?? const Duration(seconds: 10)).asyncMap((
        _,
      ) async {
        final e = await operation.count(p);
        return Response(data: e, status: Status.ok);
      });
    });
  }

  Future<List<T>> _buildAll(Iterable<Map<String, dynamic>> docs) async {
    final out = <T>[];
    for (final i in docs) {
      if (i.isEmpty) continue;
      final v = await decryptDoc(i);
      out.add(build(v));
    }
    return out;
  }
}
