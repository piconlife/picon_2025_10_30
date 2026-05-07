import 'package:flutter_entity/entity.dart' show Entity, Response, Status;

import '../cache/manager.dart' show CacheManager;
import '../operations/typedefs.dart' show Ignore;
import '../operations/writers.dart' show DataBatchWriter;
import '../sources/base.dart' show DataSource;
import '../sources/local.dart' show LocalDataSource;
import '../sources/remote.dart' show RemoteDataSource;
import '../utils/checker.dart' show Checker;
import '../utils/database_type.dart' show DatabaseType;
import '../utils/fetch_options.dart' show DataFetchOptions;
import '../utils/modifiers.dart' show DataModifiers;
import '../utils/params.dart' show DataFieldParams;
import '../utils/query.dart' show DataQuery;
import '../utils/selection.dart' show DataSelection;
import '../utils/sorting.dart' show DataSorting;
import '../utils/updating_info.dart' show DataWriter;

typedef FutureConnectivityCallback = Future<bool> Function();

class DataRepository<T extends Entity> {
  final String? id;
  final DatabaseType _type;
  final bool backupMode;
  final bool lazyMode;
  final bool restoreMode;
  final bool singletonMode;

  final DataSource<T> primary;

  final DataSource<T>? optional;

  final FutureConnectivityCallback? _connectivity;

  Future<bool> get isConnected async {
    if (_connectivity != null) return _connectivity();
    return false;
  }

  Future<bool> get isDisconnected async => !(await isConnected);

  bool get isLocalDB => _type == DatabaseType.local;

  bool isBackupMode([bool? backupMode]) {
    return optional != null && (backupMode ?? this.backupMode);
  }

  bool isLazyMode([bool? lazyMode]) => lazyMode ?? this.lazyMode;

  bool isSingletonMode([bool? singletonMode]) {
    return singletonMode ?? this.singletonMode;
  }

  const DataRepository.local({
    this.id,
    this.backupMode = true,
    this.lazyMode = true,
    this.restoreMode = true,
    this.singletonMode = false,
    required LocalDataSource<T> source,
    RemoteDataSource<T>? backup,
    FutureConnectivityCallback? connectivity,
  }) : _type = DatabaseType.local,
       primary = source,
       optional = backup,
       _connectivity = connectivity;

  const DataRepository.remote({
    this.id,
    this.backupMode = true,
    this.lazyMode = true,
    this.restoreMode = true,
    this.singletonMode = true,
    required RemoteDataSource<T> source,
    LocalDataSource<T>? backup,
    FutureConnectivityCallback? connectivity,
  }) : _type = DatabaseType.remote,
       primary = source,
       optional = backup,
       _connectivity = connectivity;

  Future<Response<S>> _backup<S extends Object>(
    Future<Response<S>> Function(DataSource<T> source) callback,
  ) async {
    try {
      if (optional == null) return Response(status: Status.undefined);
      if (isLocalDB) {
        final connected = await isConnected;
        if (!connected) return Response(status: Status.networkError);
      }
      return callback(optional!);
    } catch (error) {
      return Response(status: Status.failure, error: error.toString());
    }
  }

  Future<Response<S>> _execute<S extends Object>(
    Future<Response<S>> Function(DataSource<T> source) callback,
  ) async {
    try {
      if (!isLocalDB) {
        final connected = await isConnected;
        if (!connected) return Response(status: Status.networkError);
      }
      return callback(primary);
    } catch (error) {
      return Response(status: Status.failure, error: error.toString());
    }
  }

  Future<Response<T>> _modifier(
    DataModifiers modifierId,
    Future<Response<T>> Function() callback,
  ) async {
    try {
      return callback().then((value) => modifier(value, modifierId));
    } catch (error) {
      return Response(status: Status.failure, error: error.toString());
    }
  }

  Stream<Response<S>> _stream<S extends Object>(
    Stream<Response<S>> Function(DataSource<T> source) callback,
  ) async* {
    try {
      yield* callback(primary);
    } catch (error) {
      yield Response(status: Status.failure, error: error.toString());
    }
  }

  Stream<Response<T>> _streamModifier(
    DataModifiers modifierId,
    Stream<Response<T>> Function() callback,
  ) {
    return callback().asyncMap((value) {
      return modifier(value, modifierId);
    });
  }

  Future<Response<T>> modifier(
    Response<T> value,
    DataModifiers modifier,
  ) async {
    return value;
  }

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
    return _modifier(DataModifiers.checkById, () async {
      final feedback = await _execute((source) {
        return source.checkById(
          id,
          params: params,
          countable: countable,
          resolveRefs: resolveRefs,
          ignore: ignore,
        );
      });
      if (feedback.isValid || !isBackupMode(backupMode)) return feedback;
      final backup = await _backup((source) {
        return source.checkById(
          id,
          params: params,
          countable: countable,
          resolveRefs: resolveRefs,
          ignore: ignore,
        );
      });
      if (backup.isValid) {
        if (isLazyMode(lazyMode)) {
          _execute((source) {
            return source.creates(
              backup.result.map((e) => DataWriter(id: e.id, data: e.filtered)),
              params: params,
              createRefs: createRefs ?? resolveRefs,
              merge: merge,
            );
          });
        } else {
          await _execute((source) {
            return source.creates(
              backup.result.map((e) => DataWriter(id: e.id, data: e.filtered)),
              params: params,
              createRefs: createRefs ?? resolveRefs,
              merge: merge,
            );
          });
        }
      }
      return backup;
    });
  }

  Future<Response<T>> clear({
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool deleteRefs = false,
    bool counter = false,
    bool? lazyMode,
    bool? backupMode,
  }) {
    return _modifier(DataModifiers.clear, () async {
      if (isBackupMode(backupMode)) {
        if (isLazyMode(lazyMode)) {
          _backup((source) {
            return source.clear(
              params: params,
              counter: counter,
              resolveRefs: resolveRefs,
              ignore: ignore,
              deleteRefs: deleteRefs,
            );
          });
        } else {
          await _backup((source) {
            return source.clear(
              params: params,
              counter: counter,
              resolveRefs: resolveRefs,
              ignore: ignore,
              deleteRefs: deleteRefs,
            );
          });
        }
      }
      return _execute((source) {
        return source.clear(
          params: params,
          counter: counter,
          resolveRefs: resolveRefs,
          ignore: ignore,
          deleteRefs: deleteRefs,
        );
      });
    });
  }

  Future<Response<int>> count({
    DataFieldParams? params,
    bool? backupMode,
  }) async {
    final feedback = await _execute((source) {
      return source.count(params: params);
    });
    if (feedback.isValid || !isBackupMode(backupMode)) return feedback;
    final backup = await _backup((source) {
      return source.count(params: params);
    });
    return feedback.copyWith(data: backup.data);
  }

  Future<Response<T>> create(
    T data, {
    DataFieldParams? params,
    bool merge = true,
    bool createRefs = false,
    bool? lazyMode,
    bool? backupMode,
  }) {
    return createById(
      data.id,
      data.filtered,
      params: params,
      merge: merge,
      createRefs: createRefs,
      lazyMode: lazyMode,
      backupMode: backupMode,
    );
  }

  Future<Response<T>> createById(
    String id,
    Map<String, dynamic> data, {
    DataFieldParams? params,
    bool merge = true,
    bool createRefs = false,
    bool? lazyMode,
    bool? backupMode,
  }) {
    return _modifier(DataModifiers.create, () async {
      if (isBackupMode(backupMode)) {
        if (isLazyMode(lazyMode)) {
          _backup((source) {
            return source.create(
              id,
              data,
              params: params,
              createRefs: createRefs,
              merge: merge,
            );
          });
        } else {
          await _backup((source) {
            return source.create(
              id,
              data,
              params: params,
              createRefs: createRefs,
              merge: merge,
            );
          });
        }
      }
      return _execute((source) {
        return source.create(
          id,
          data,
          params: params,
          createRefs: createRefs,
          merge: merge,
        );
      });
    });
  }

  Future<Response<T>> creates(
    Iterable<T> data, {
    DataFieldParams? params,
    bool merge = true,
    bool createRefs = false,
    bool? lazyMode,
    bool? backupMode,
  }) {
    return createByWriters(
      data.map((e) => DataWriter(id: e.id, data: e.filtered)),
      params: params,
      merge: merge,
      createRefs: createRefs,
      lazyMode: lazyMode,
      backupMode: backupMode,
    );
  }

  Future<Response<T>> createByWriters(
    Iterable<DataWriter> writers, {
    DataFieldParams? params,
    bool merge = true,
    bool createRefs = false,
    bool? lazyMode,
    bool? backupMode,
  }) {
    return _modifier(DataModifiers.creates, () async {
      if (isBackupMode(backupMode)) {
        if (isLazyMode(lazyMode)) {
          _backup((source) {
            return source.creates(
              writers,
              params: params,
              merge: merge,
              createRefs: createRefs,
            );
          });
        } else {
          await _backup((source) {
            return source.creates(
              writers,
              params: params,
              merge: merge,
              createRefs: createRefs,
            );
          });
        }
      }
      return _execute((source) {
        return source.creates(
          writers,
          params: params,
          merge: merge,
          createRefs: createRefs,
        );
      });
    });
  }

  Future<Response<T>> deleteById(
    String id, {
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool counter = false,
    bool deleteRefs = false,
    bool? lazyMode,
    bool? backupMode,
  }) {
    return _modifier(DataModifiers.deleteById, () async {
      if (isBackupMode(backupMode)) {
        if (isLazyMode(lazyMode)) {
          _backup((source) {
            return source.deleteById(
              id,
              params: params,
              counter: counter,
              resolveRefs: resolveRefs,
              ignore: ignore,
              deleteRefs: deleteRefs,
            );
          });
        } else {
          await _backup((source) {
            return source.deleteById(
              id,
              params: params,
              counter: counter,
              resolveRefs: resolveRefs,
              ignore: ignore,
              deleteRefs: deleteRefs,
            );
          });
        }
      }
      return _execute((source) {
        return source.deleteById(
          id,
          params: params,
          counter: counter,
          resolveRefs: resolveRefs,
          ignore: ignore,
          deleteRefs: deleteRefs,
        );
      });
    });
  }

  Future<Response<T>> deleteByIds(
    Iterable<String> ids, {
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool counter = false,
    bool deleteRefs = false,
    bool? lazyMode,
    bool? backupMode,
  }) {
    return _modifier(DataModifiers.deleteByIds, () async {
      if (isBackupMode(backupMode)) {
        if (isLazyMode(lazyMode)) {
          _backup((source) {
            return source.deleteByIds(
              ids,
              params: params,
              counter: counter,
              resolveRefs: resolveRefs,
              ignore: ignore,
              deleteRefs: deleteRefs,
            );
          });
        } else {
          await _backup((source) {
            return source.deleteByIds(
              ids,
              params: params,
              counter: counter,
              resolveRefs: resolveRefs,
              ignore: ignore,
              deleteRefs: deleteRefs,
            );
          });
        }
      }
      return _execute((source) {
        return source.deleteByIds(
          ids,
          params: params,
          counter: counter,
          resolveRefs: resolveRefs,
          ignore: ignore,
          deleteRefs: deleteRefs,
        );
      });
    });
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
    return _modifier(DataModifiers.get, () async {
      final feedback = await CacheManager.i.cache(
        "GET",
        enabled: isSingletonMode(singletonMode),
        keyProps: [
          params,
          countable,
          onlyUpdates,
          resolveRefs,
          resolveDocChangesRefs,
        ],
        callback:
            () => _execute((source) {
              return source.get(
                params: params,
                countable: countable,
                resolveRefs: resolveRefs,
                resolveDocChangesRefs: resolveDocChangesRefs,
                ignore: ignore,
                onlyUpdates: onlyUpdates,
              );
            }),
      );
      if (feedback.isValid || !isBackupMode(backupMode)) return feedback;
      final backup = await _backup((source) {
        return source.get(
          params: params,
          countable: countable,
          resolveRefs: resolveRefs,
          resolveDocChangesRefs: resolveDocChangesRefs,
          ignore: ignore,
          onlyUpdates: onlyUpdates,
        );
      });
      if (backup.isValid) {
        if (isLazyMode(lazyMode)) {
          _execute((source) {
            return source.creates(
              backup.result.map((e) => DataWriter(id: e.id, data: e.filtered)),
              params: params,
              createRefs: createRefs ?? resolveRefs,
              merge: merge,
            );
          });
        } else {
          await _execute((source) {
            return source.creates(
              backup.result.map((e) => DataWriter(id: e.id, data: e.filtered)),
              params: params,
              createRefs: createRefs ?? resolveRefs,
              merge: merge,
            );
          });
        }
      }
      return backup;
    });
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
    return _modifier(DataModifiers.getById, () async {
      final feedback = await CacheManager.i.cache(
        "GET_BY_ID",
        enabled: isSingletonMode(singletonMode),
        keyProps: [id, params, countable, resolveRefs],
        callback:
            () => _execute((source) {
              return source.getById(
                id,
                params: params,
                countable: countable,
                resolveRefs: resolveRefs,
                ignore: ignore,
              );
            }),
      );
      if (feedback.isValid || !isBackupMode(backupMode)) return feedback;
      final backup = await _backup((source) {
        return source.getById(
          id,
          params: params,
          countable: countable,
          resolveRefs: resolveRefs,
          ignore: ignore,
        );
      });
      if (backup.isValid) {
        if (isLazyMode(lazyMode)) {
          _execute((source) {
            return source.creates(
              backup.result.map((e) => DataWriter(id: e.id, data: e.filtered)),
              params: params,
              createRefs: createRefs ?? resolveRefs,
              merge: merge,
            );
          });
        } else {
          await _execute((source) {
            return source.creates(
              backup.result.map((e) => DataWriter(id: e.id, data: e.filtered)),
              params: params,
              createRefs: createRefs ?? resolveRefs,
              merge: merge,
            );
          });
        }
      }
      return backup;
    });
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
    return _modifier(DataModifiers.getByIds, () async {
      final feedback = await CacheManager.i.cache(
        "GET_BY_IDS",
        enabled: isSingletonMode(singletonMode),
        keyProps: [...ids, params, resolveRefs, resolveDocChangesRefs],
        callback:
            () => _execute((source) {
              return source.getByIds(
                ids,
                params: params,
                countable: countable,
                resolveRefs: resolveRefs,
                resolveDocChangesRefs: resolveDocChangesRefs,
                ignore: ignore,
              );
            }),
      );
      if (feedback.isValid || !isBackupMode(backupMode)) return feedback;
      final backup = await _backup((source) {
        return source.getByIds(
          ids,
          params: params,
          countable: countable,
          resolveRefs: resolveRefs,
          resolveDocChangesRefs: resolveDocChangesRefs,
          ignore: ignore,
        );
      });
      if (backup.isValid) {
        if (isLazyMode(lazyMode)) {
          _execute((source) {
            return source.creates(
              backup.result.map((e) => DataWriter(id: e.id, data: e.filtered)),
              params: params,
              createRefs: createRefs ?? resolveRefs,
              merge: merge,
            );
          });
        } else {
          await _execute((source) {
            return source.creates(
              backup.result.map((e) => DataWriter(id: e.id, data: e.filtered)),
              params: params,
              createRefs: createRefs ?? resolveRefs,
              merge: merge,
            );
          });
        }
      }
      return backup;
    });
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
    return _modifier(DataModifiers.getByQuery, () async {
      final feedback = await CacheManager.i.cache(
        "GET_BY_QUERY",
        enabled: isSingletonMode(singletonMode),
        keyProps: [
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
        callback:
            () => _execute((source) {
              return source.getByQuery(
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
              );
            }),
      );
      if (feedback.isValid || !isBackupMode(backupMode)) return feedback;
      final backup = await _backup((source) {
        return source.getByQuery(
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
        );
      });
      if (backup.isValid) {
        if (isLazyMode(lazyMode)) {
          _execute((source) {
            return source.creates(
              backup.result.map((e) => DataWriter(id: e.id, data: e.filtered)),
              params: params,
              createRefs: createRefs ?? resolveRefs,
              merge: merge,
            );
          });
        } else {
          await _execute((source) {
            return source.creates(
              backup.result.map((e) => DataWriter(id: e.id, data: e.filtered)),
              params: params,
              createRefs: createRefs ?? resolveRefs,
              merge: merge,
            );
          });
        }
      }
      return backup;
    });
  }

  Stream<Response<T>> listen({
    DataFieldParams? params,
    bool? countable,
    bool onlyUpdates = false,
    bool resolveRefs = false,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
  }) {
    return _streamModifier(DataModifiers.listen, () {
      return _stream((source) {
        return source.listen(
          params: params,
          countable: countable,
          resolveRefs: resolveRefs,
          resolveDocChangesRefs: resolveDocChangesRefs,
          onlyUpdates: onlyUpdates,
          ignore: ignore,
        );
      });
    });
  }

  Stream<Response<int>> listenCount({
    DataFieldParams? params,
    Duration? interval,
  }) {
    return _stream((source) {
      return source.listenCount(params: params, interval: interval);
    });
  }

  Stream<Response<T>> listenById(
    String id, {
    DataFieldParams? params,
    bool? countable,
    bool resolveRefs = false,
    Ignore? ignore,
  }) {
    return _streamModifier(DataModifiers.listenById, () {
      return _stream((source) {
        return source.listenById(
          id,
          params: params,
          countable: countable,
          resolveRefs: resolveRefs,
          ignore: ignore,
        );
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
    return _streamModifier(DataModifiers.listenByIds, () {
      return _stream((source) {
        return source.listenByIds(
          ids,
          params: params,
          countable: countable,
          resolveRefs: resolveRefs,
          resolveDocChangesRefs: resolveDocChangesRefs,
          ignore: ignore,
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
    return _streamModifier(DataModifiers.listenByQuery, () {
      return _stream((source) {
        return source.listenByQuery(
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
        );
      });
    });
  }

  Future<void> restore({
    DataFieldParams? params,
    bool onlyUpdates = false,
    bool? countable,
    bool? resolveRefs,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
    bool createRefs = false,
    bool merge = true,
    bool? lazyMode,
  }) async {
    if (!restoreMode || !isBackupMode(backupMode)) return;
    final backup = await _backup((source) {
      return source.get(
        params: params,
        countable: countable,
        resolveRefs: resolveRefs ?? createRefs,
        resolveDocChangesRefs: resolveDocChangesRefs,
        onlyUpdates: onlyUpdates,
        ignore: ignore,
      );
    });
    if (!backup.isValid) return;
    if (isLazyMode(lazyMode)) {
      _execute((source) {
        return source.creates(
          backup.result.map((e) => DataWriter(id: e.id, data: e.filtered)),
          params: params,
          createRefs: createRefs,
          merge: merge,
        );
      });
    } else {
      await _execute((source) {
        return source.creates(
          backup.result.map((e) => DataWriter(id: e.id, data: e.filtered)),
          params: params,
          createRefs: createRefs,
          merge: merge,
        );
      });
    }
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
    return _modifier(DataModifiers.search, () async {
      final feedback = await _execute((source) {
        return source.search(
          checker,
          params: params,
          countable: countable,
          resolveRefs: resolveRefs,
          resolveDocChangesRefs: resolveDocChangesRefs,
          ignore: ignore,
        );
      });
      if (feedback.isValid || !isBackupMode(backupMode)) return feedback;
      final backup = await _backup((source) {
        return source.search(
          checker,
          params: params,
          countable: countable,
          resolveRefs: resolveRefs,
          resolveDocChangesRefs: resolveDocChangesRefs,
          ignore: ignore,
        );
      });
      if (backup.isValid) {
        if (isLazyMode(lazyMode)) {
          _execute((source) {
            return source.creates(
              backup.result.map((e) => DataWriter(id: e.id, data: e.filtered)),
              params: params,
              createRefs: createRefs ?? resolveRefs,
              merge: merge,
            );
          });
        } else {
          await _execute((source) {
            return source.creates(
              backup.result.map((e) => DataWriter(id: e.id, data: e.filtered)),
              params: params,
              createRefs: createRefs ?? resolveRefs,
              merge: merge,
            );
          });
        }
      }
      return backup;
    });
  }

  Future<Response<T>> updateById(
    String id,
    Map<String, dynamic> data, {
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool updateRefs = false,
    bool? lazyMode,
    bool? backupMode,
  }) {
    return _modifier(DataModifiers.updateById, () async {
      if (isBackupMode(backupMode)) {
        if (isLazyMode(lazyMode)) {
          _backup((source) {
            return source.updateById(
              id,
              data,
              params: params,
              resolveRefs: resolveRefs,
              ignore: ignore,
              updateRefs: updateRefs,
            );
          });
        } else {
          await _backup((source) {
            return source.updateById(
              id,
              data,
              params: params,
              resolveRefs: resolveRefs,
              ignore: ignore,
              updateRefs: updateRefs,
            );
          });
        }
      }
      return _execute((source) {
        return source.updateById(
          id,
          data,
          params: params,
          resolveRefs: resolveRefs,
          ignore: ignore,
          updateRefs: updateRefs,
        );
      });
    });
  }

  Future<Response<T>> updateByIds(
    Iterable<DataWriter> updates, {
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool updateRefs = false,
    bool? lazyMode,
    bool? backupMode,
  }) {
    return _modifier(DataModifiers.updateByIds, () async {
      if (isBackupMode(backupMode)) {
        if (isLazyMode(lazyMode)) {
          _backup((source) {
            return source.updateByIds(
              updates,
              params: params,
              resolveRefs: resolveRefs,
              ignore: ignore,
              updateRefs: updateRefs,
            );
          });
        } else {
          await _backup((source) {
            return source.updateByIds(
              updates,
              params: params,
              resolveRefs: resolveRefs,
              ignore: ignore,
              updateRefs: updateRefs,
            );
          });
        }
      }
      return _execute((source) {
        return source.updateByIds(
          updates,
          params: params,
          resolveRefs: resolveRefs,
          ignore: ignore,
          updateRefs: updateRefs,
        );
      });
    });
  }

  Future<Response<void>> write(List<DataBatchWriter> writers) {
    return _execute((source) async {
      final response = await source.write(writers);
      return response.isSuccessful
          ? Response.ok()
          : Response.failure(response.error);
    });
  }
}
