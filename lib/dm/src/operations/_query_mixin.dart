part of 'operation.dart';

mixin _QueryMixin on _ErrorHandlingMixin, _HydrateMixin {
  DataDelegate get delegate;

  Future<DataGetsSnapshot> doGet(
    String path, {
    required bool countable,
    required bool resolveRefs,
    required bool resolveDocChangesRefs,
    required Ignore? ignore,
  }) async {
    final data = await guardAsync<DataGetsSnapshot>(
      () => delegate.get(path),
      operation: 'get',
      path: path,
    );
    return hydrateMany(
      data,
      countable: countable,
      resolveRefs: resolveRefs,
      resolveDocChangesRefs: resolveDocChangesRefs,
      ignore: ignore,
    );
  }

  Future<DataGetSnapshot> doGetById(
    String path, {
    required bool countable,
    required bool resolveRefs,
    required Ignore? ignore,
  }) async {
    final data = await guardAsync<DataGetSnapshot>(
      () => delegate.getById(path),
      operation: 'getById',
      path: path,
    );
    return hydrateOne(
      data,
      countable: countable,
      resolveRefs: resolveRefs,
      ignore: ignore,
    );
  }

  Future<DataGetsSnapshot> doGetByQuery(
    String path, {
    required Iterable<DataQuery> queries,
    required Iterable<DataSelection> selections,
    required Iterable<DataSorting> sorts,
    required DataFetchOptions options,
    required bool countable,
    required bool resolveRefs,
    required bool resolveDocChangesRefs,
    required Ignore? ignore,
  }) async {
    final data = await guardAsync<DataGetsSnapshot>(
      () => delegate.getByQuery(
        path,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
      ),
      operation: 'getByQuery',
      path: path,
    );
    return hydrateMany(
      data,
      countable: countable,
      resolveRefs: resolveRefs,
      resolveDocChangesRefs: resolveDocChangesRefs,
      ignore: ignore,
    );
  }

  Future<DataGetsSnapshot> doSearch(
    String path,
    Checker checker, {
    required bool countable,
    required bool resolveRefs,
    required bool resolveDocChangesRefs,
    required Ignore? ignore,
  }) async {
    final data = await guardAsync<DataGetsSnapshot>(
      () => delegate.search(path, checker),
      operation: 'search',
      path: path,
    );
    return hydrateMany(
      data,
      countable: countable,
      resolveRefs: resolveRefs,
      resolveDocChangesRefs: resolveDocChangesRefs,
      ignore: ignore,
    );
  }
}
