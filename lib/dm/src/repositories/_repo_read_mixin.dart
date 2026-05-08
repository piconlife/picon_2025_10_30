part of 'base.dart';

mixin _RepoReadMixin<T extends Entity>
    on
        _RepoExecutorMixin<T>,
        _RepoModifierMixin<T>,
        _RepoReadWithFallbackMixin<T> {
  Future<Response<T>> checkById(
    String id, {
    DataFieldParams? params,
    bool merge = true,
    bool? createRefs,
    bool? countable,
    bool resolveRefs = false,
    Ignore? ignore,
    bool? lazyMode,
    bool? backupMode,
  }) {
    return readWithFallback(
      modifierId: DataModifiers.checkById,
      params: params,
      createRefs: createRefs,
      resolveRefs: resolveRefs,
      merge: merge,
      lazyMode: lazyMode,
      backupMode: backupMode,
      read:
          (source) => source.checkById(
            id,
            params: params,
            countable: countable,
            resolveRefs: resolveRefs,
            ignore: ignore,
          ),
    );
  }

  Future<Response<int>> count({
    DataFieldParams? params,
    bool? backupMode,
  }) async {
    final feedback = await runOnPrimary(
      (source) => source.count(params: params),
    );
    if (feedback.isValid || !shouldUseBackup(backupMode)) return feedback;
    final backup = await runOnBackup((source) => source.count(params: params));
    return backup;
  }

  Future<Response<T>> get({
    DataFieldParams? params,
    bool? countable,
    bool onlyUpdates = false,
    bool resolveRefs = false,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
    bool? createRefs,
    bool merge = true,
    bool? lazyMode,
    bool? backupMode,
    bool? singletonMode,
  }) {
    return readWithFallback(
      modifierId: DataModifiers.get,
      params: params,
      createRefs: createRefs,
      resolveRefs: resolveRefs,
      merge: merge,
      lazyMode: lazyMode,
      backupMode: backupMode,
      singletonMode: singletonMode,
      cacheKey: 'GET',
      cacheKeyProps: [
        params,
        countable,
        onlyUpdates,
        resolveRefs,
        resolveDocChangesRefs,
      ],
      read:
          (source) => source.get(
            params: params,
            countable: countable,
            resolveRefs: resolveRefs,
            resolveDocChangesRefs: resolveDocChangesRefs,
            ignore: ignore,
            onlyUpdates: onlyUpdates,
          ),
    );
  }

  Future<Response<T>> getById(
    String id, {
    DataFieldParams? params,
    bool? countable,
    bool resolveRefs = false,
    Ignore? ignore,
    bool? createRefs,
    bool merge = true,
    bool? lazyMode,
    bool? singletonMode,
    bool? backupMode,
  }) {
    return readWithFallback(
      modifierId: DataModifiers.getById,
      params: params,
      createRefs: createRefs,
      resolveRefs: resolveRefs,
      merge: merge,
      lazyMode: lazyMode,
      backupMode: backupMode,
      singletonMode: singletonMode,
      cacheKey: 'GET_BY_ID',
      cacheKeyProps: [id, params, countable, resolveRefs],
      read:
          (source) => source.getById(
            id,
            params: params,
            countable: countable,
            resolveRefs: resolveRefs,
            ignore: ignore,
          ),
    );
  }

  Future<Response<T>> getByIds(
    Iterable<String> ids, {
    DataFieldParams? params,
    bool? countable,
    bool resolveRefs = false,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
    bool? createRefs,
    bool merge = true,
    bool? lazyMode,
    bool? backupMode,
    bool? singletonMode,
  }) {
    final stableIds = ids.toList()..sort();
    return readWithFallback(
      modifierId: DataModifiers.getByIds,
      params: params,
      createRefs: createRefs,
      resolveRefs: resolveRefs,
      merge: merge,
      lazyMode: lazyMode,
      backupMode: backupMode,
      singletonMode: singletonMode,
      cacheKey: 'GET_BY_IDS',
      cacheKeyProps: [...stableIds, params, resolveRefs, resolveDocChangesRefs],
      read:
          (source) => source.getByIds(
            ids,
            params: params,
            countable: countable,
            resolveRefs: resolveRefs,
            resolveDocChangesRefs: resolveDocChangesRefs,
            ignore: ignore,
          ),
    );
  }

  Future<Response<T>> getByQuery({
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
    bool? createRefs,
    bool merge = true,
    bool? lazyMode,
    bool? backupMode,
    bool? singletonMode,
  }) {
    return readWithFallback(
      modifierId: DataModifiers.getByQuery,
      params: params,
      createRefs: createRefs,
      resolveRefs: resolveRefs,
      merge: merge,
      lazyMode: lazyMode,
      backupMode: backupMode,
      singletonMode: singletonMode,
      cacheKey: 'GET_BY_QUERY',
      cacheKeyProps: [
        params,
        ...queries,
        ...selections,
        ...sorts,
        options,
        countable,
        onlyUpdates,
        resolveRefs,
        resolveDocChangesRefs,
      ],
      read:
          (source) => source.getByQuery(
            params: params,
            queries: queries,
            selections: selections,
            sorts: sorts,
            options: options,
            countable: countable,
            onlyUpdates: onlyUpdates,
            resolveRefs: resolveRefs,
            resolveDocChangesRefs: resolveDocChangesRefs,
            ignore: ignore,
          ),
    );
  }

  Future<Response<T>> search(
    Checker checker, {
    DataFieldParams? params,
    bool? countable,
    bool resolveRefs = false,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
    bool? createRefs,
    bool merge = true,
    bool? lazyMode,
    bool? backupMode,
  }) {
    return readWithFallback(
      modifierId: DataModifiers.search,
      params: params,
      createRefs: createRefs,
      resolveRefs: resolveRefs,
      merge: merge,
      lazyMode: lazyMode,
      backupMode: backupMode,
      read:
          (source) => source.search(
            checker,
            params: params,
            countable: countable,
            resolveRefs: resolveRefs,
            resolveDocChangesRefs: resolveDocChangesRefs,
            ignore: ignore,
          ),
    );
  }
}
