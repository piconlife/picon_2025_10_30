part of 'base.dart';

mixin _SourceListenMixin<T extends Entity> on _SourceReadBaseMixin<T> {
  Stream<Response<T>> listen({
    DataFieldParams? params,
    bool? countable,
    bool onlyUpdates = false,
    bool resolveRefs = false,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
  }) {
    return _executeStream(() {
      final p = _ref(params, DataModifiers.listen);
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
    return _executeStream(() {
      final p = _ref(params, DataModifiers.listenById, id);
      return operation
          .listenById(
            p,
            countable: countable ?? false,
            resolveRefs: resolveRefs,
            ignore: ignore,
          )
          .asyncMap((event) async {
            if (!event.exists) return Response(status: Status.notFound);
            final v = await _decryptDoc(event.doc);
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
    return _executeStream(() {
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
      final p = _ref(params, DataModifiers.listenByIds);
      final adjustedQueries = [
        DataQuery(DataFieldPath.documentId, whereIn: ids),
      ].map(
        (e) => e.adjust(delegate.resolveFieldPath, delegate.resolveFieldValue),
      );
      return operation
          .listenByQuery(
            p,
            countable: countable ?? false,
            resolveRefs: resolveRefs,
            resolveDocChangesRefs: resolveDocChangesRefs,
            ignore: ignore,
            queries: adjustedQueries,
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
    return _executeStream(() {
      final p = _ref(params, DataModifiers.listenByQuery);
      final adjustedQueries = queries.map(
        (e) => e.adjust(delegate.resolveFieldPath, delegate.resolveFieldValue),
      );
      return operation
          .listenByQuery(
            p,
            queries: adjustedQueries,
            selections: selections,
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
    return _executeStream(() {
      final p = _ref(params, DataModifiers.listenCount);
      return Stream.periodic(interval ?? const Duration(seconds: 10)).asyncMap((
        _,
      ) async {
        try {
          final e = await operation.count(p);
          if (e == null) {
            return Response(status: Status.networkError);
          }
          return Response(data: e, status: Status.ok);
        } catch (error) {
          return Response(status: Status.networkError, error: error.toString());
        }
      });
    });
  }
}
