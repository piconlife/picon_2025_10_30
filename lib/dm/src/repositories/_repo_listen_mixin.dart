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
    return applyStreamModifier(DataModifiers.listen, () {
      return streamOnPrimary(
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
  }) {
    return streamOnPrimary(
      (source) => source.listenCount(params: params, interval: interval),
    );
  }

  Stream<Response<T>> listenById(
    String id, {
    DataFieldParams? params,
    bool? countable,
    bool resolveRefs = false,
    Ignore? ignore,
  }) {
    return applyStreamModifier(DataModifiers.listenById, () {
      return streamOnPrimary(
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
    return applyStreamModifier(DataModifiers.listenByIds, () {
      return streamOnPrimary(
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
    return applyStreamModifier(DataModifiers.listenByQuery, () {
      return streamOnPrimary(
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
