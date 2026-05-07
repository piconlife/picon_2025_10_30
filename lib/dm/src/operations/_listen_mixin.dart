part of 'operation.dart';

mixin _ListenMixin on _ErrorHandlingMixin, _HydrateMixin {
  DataDelegate get delegate;

  Stream<DataGetsSnapshot> doListen(
    String path, {
    required bool countable,
    required bool resolveRefs,
    required bool resolveDocChangesRefs,
    required Ignore? ignore,
  }) {
    return _guardStream(
      () => delegate.listen(path),
      operation: 'listen',
      path: path,
      empty: DataGetsSnapshot(),
    ).asyncMap(
      (data) => hydrateMany(
        data,
        countable: countable,
        resolveRefs: resolveRefs,
        resolveDocChangesRefs: resolveDocChangesRefs,
        ignore: ignore,
      ),
    );
  }

  Stream<DataGetSnapshot> doListenById(
    String path, {
    required bool countable,
    required bool resolveRefs,
    required Ignore? ignore,
  }) {
    return _guardStream(
      () => delegate.listenById(path),
      operation: 'listenById',
      path: path,
      empty: DataGetSnapshot(),
    ).asyncMap(
      (data) => hydrateOne(
        data,
        countable: countable,
        resolveRefs: resolveRefs,
        ignore: ignore,
      ),
    );
  }

  Stream<DataGetsSnapshot> doListenByQuery(
    String path, {
    required Iterable<DataQuery> queries,
    required Iterable<DataSelection> selections,
    required Iterable<DataSorting> sorts,
    required DataFetchOptions options,
    required bool countable,
    required bool resolveRefs,
    required bool resolveDocChangesRefs,
    required Ignore? ignore,
  }) {
    return _guardStream(
      () => delegate.listenByQuery(
        path,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
      ),
      operation: 'listenByQuery',
      path: path,
      empty: DataGetsSnapshot(),
    ).asyncMap(
      (data) => hydrateMany(
        data,
        countable: countable,
        resolveRefs: resolveRefs,
        resolveDocChangesRefs: resolveDocChangesRefs,
        ignore: ignore,
      ),
    );
  }

  Stream<T> _guardStream<T>(
    Stream<T> Function() source, {
    required String operation,
    required String path,
    required T empty,
  }) async* {
    try {
      yield* source().handleError((Object e, StackTrace s) {
        errorDelegate.onError(
          DataOperationError(
            operation: operation,
            path: path,
            cause: e,
            stack: s,
          ),
        );
      });
    } catch (e, s) {
      errorDelegate.onError(
        DataOperationError(
          operation: operation,
          path: path,
          cause: e,
          stack: s,
        ),
      );
      yield empty;
    }
  }
}
