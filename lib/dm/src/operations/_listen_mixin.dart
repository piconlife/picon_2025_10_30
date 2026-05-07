part of 'operation.dart';

mixin _ListenMixin on _HydrateMixin {
  DataDelegate get delegate;

  Stream<DataGetsSnapshot> doListen(
    String path, {
    required bool countable,
    required bool resolveRefs,
    required bool resolveDocChangesRefs,
    required Ignore? ignore,
  }) {
    return delegate
        .listen(path)
        .asyncMap(
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
    return delegate
        .listenById(path)
        .asyncMap(
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
    return delegate
        .listenByQuery(
          path,
          queries: queries,
          selections: selections,
          sorts: sorts,
          options: options,
        )
        .asyncMap(
          (data) => hydrateMany(
            data,
            countable: countable,
            resolveRefs: resolveRefs,
            resolveDocChangesRefs: resolveDocChangesRefs,
            ignore: ignore,
          ),
        );
  }
}
