part of 'base.dart';

mixin _RepoListenMixin<T extends Entity>
    on _RepoExecutorMixin<T>, _RepoModifierMixin<T> {
  Stream<Response<S>> _streamWithFallback<S extends Object>(
    Stream<Response<S>> Function(DataSource<T> source) build,
  ) {
    if (isLocalDB || optional == null) {
      return _streamOnPrimary(build);
    }
    return _FallbackStream<T, S>(
      primary: primary,
      backup: optional!,
      resolveConnected: () => isConnected,
      connectivityChanges: () => DM.i.connectivityChanges,
      build: build,
      report: _report,
    ).stream;
  }

  Stream<Response<T>> listen({
    DataFieldParams? params,
    bool? countable,
    bool onlyUpdates = false,
    bool resolveRefs = false,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
  }) {
    return _applyStreamModifier<T>(DataModifiers.listen, () {
      return _streamWithFallback(
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

  Stream<Response<int>> listenCount({DataFieldParams? params}) {
    return _applyStreamModifier<int>(DataModifiers.listenCount, () {
      return _streamWithFallback(
        (source) => source.listenCount(params: params),
      );
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
      return _streamWithFallback(
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
      return Stream.value(Response(status: Status.invalidId));
    }
    return _applyStreamModifier<T>(DataModifiers.listenByIds, () {
      return _streamWithFallback(
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
      return _streamWithFallback(
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
