part of 'base.dart';

mixin _RepoListenMixin<T extends Entity>
    on _RepoExecutorMixin<T>, _RepoModifierMixin<T> {
  Stream<Response<T>> listen({
    DataFieldParams? params,
    bool? countable,
    bool onlyUpdates = false,
    bool resolveRefs = false,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
  }) {
    return _applyStreamModifier<T>(DataModifiers.listen, () {
      return _streamOnPrimary(
        (source) => source.listen(
          params: params,
          countable: countable,
          resolveRefs: resolveRefs,
          resolveDocChangesRefs: resolveDocChangesRefs,
          onlyUpdates: onlyUpdates,
          ignore: ignore,
        ),
      );
    });
  }

  Stream<Response<int>> listenCount({
    DataFieldParams? params,
    Duration? interval,
    bool? backupMode,
  }) async* {
    final tick = interval ?? const Duration(seconds: 10);
    yield* Stream.periodic(tick).asyncMap((_) async {
      final primary = await _runOnPrimary(
        (source) => source.count(params: params),
      );
      if (primary.isValid) return primary;
      if (!_shouldUseBackup(backupMode)) return primary;
      final backup = await _runOnBackup(
        (source) => source.count(params: params),
      );
      if (backup.isValid) return backup;
      return primary;
    });
  }

  Stream<Response<T>> listenById(
    String id, {
    DataFieldParams? params,
    bool? countable,
    bool resolveRefs = false,
    Ignore? ignore,
  }) {
    if (id.isEmpty) {
      return Stream.value(Response(status: Status.invalidId));
    }
    return _applyStreamModifier<T>(DataModifiers.listenById, () {
      return _streamOnPrimary(
        (source) => source.listenById(
          id,
          params: params,
          countable: countable,
          resolveRefs: resolveRefs,
          ignore: ignore,
        ),
      );
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
    if (ids.isEmpty) {
      return Stream.value(Response(status: Status.invalid));
    }
    return _applyStreamModifier<T>(DataModifiers.listenByIds, () {
      return _streamOnPrimary(
        (source) => source.listenByIds(
          ids,
          params: params,
          countable: countable,
          resolveRefs: resolveRefs,
          resolveDocChangesRefs: resolveDocChangesRefs,
          ignore: ignore,
        ),
      );
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
    return _applyStreamModifier<T>(DataModifiers.listenByQuery, () {
      return _streamOnPrimary(
        (source) => source.listenByQuery(
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
    });
  }
}
