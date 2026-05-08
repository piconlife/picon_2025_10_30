import 'package:flutter_entity/entity.dart' show Entity, Response, Status;

import '../cache/base.dart' show CacheManager;
import '../operations/error_delegate.dart' show ErrorDelegate;
import '../operations/exception.dart' show DataOperationError;
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

part '_repo_dual_write_mixin.dart';
part '_repo_executor_mixin.dart';
part '_repo_listen_mixin.dart';
part '_repo_modifier_mixin.dart';
part '_repo_read_mixin.dart';
part '_repo_read_with_fallback_mixin.dart';
part '_repo_write_mixin.dart';

typedef FutureConnectivityCallback = Future<bool> Function();

class DataRepository<T extends Entity>
    with
        _RepoExecutorMixin<T>,
        _RepoModifierMixin<T>,
        _RepoDualWriteMixin<T>,
        _RepoReadWithFallbackMixin<T>,
        _RepoReadMixin<T>,
        _RepoWriteMixin<T>,
        _RepoListenMixin<T> {
  final String? id;

  @override
  final DatabaseType type;

  @override
  final bool backupMode;

  @override
  final bool lazyMode;

  final bool restoreMode;

  @override
  final bool singletonMode;

  @override
  final DataSource<T> primary;

  @override
  final DataSource<T>? optional;

  @override
  final ErrorDelegate errorDelegate;

  final FutureConnectivityCallback? _connectivity;

  DataRepository.local({
    this.id,
    this.backupMode = true,
    this.lazyMode = true,
    this.restoreMode = true,
    this.singletonMode = false,
    required LocalDataSource<T> source,
    RemoteDataSource<T>? backup,
    FutureConnectivityCallback? connectivity,
    ErrorDelegate? errorDelegate,
  }) : type = DatabaseType.local,
       primary = source,
       optional = backup,
       _connectivity = connectivity,
       errorDelegate = errorDelegate ?? ErrorDelegate.printing;

  DataRepository.remote({
    this.id,
    this.backupMode = true,
    this.lazyMode = true,
    this.restoreMode = true,
    this.singletonMode = true,
    required RemoteDataSource<T> source,
    LocalDataSource<T>? backup,
    FutureConnectivityCallback? connectivity,
    ErrorDelegate? errorDelegate,
  }) : type = DatabaseType.remote,
       primary = source,
       optional = backup,
       _connectivity = connectivity,
       errorDelegate = errorDelegate ?? ErrorDelegate.printing;

  @override
  Future<bool> get isConnected async {
    if (_connectivity != null) return _connectivity();
    return false;
  }

  Future<bool> get isDisconnected async => !(await isConnected);

  @override
  bool get isLocalDB => type == DatabaseType.local;

  @override
  Future<Response<T>> modifier(
    Response<T> value,
    DataModifiers modifier,
  ) async {
    return value;
  }

  Future<Response<void>> restore({
    DataFieldParams? params,
    bool onlyUpdates = false,
    bool? countable,
    bool? resolveRefs,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
    bool createRefs = false,
    bool merge = true,
    bool? lazyMode,
    bool? backupMode,
  }) async {
    if (!restoreMode) {
      return Response(status: Status.canceled, error: 'restoreMode disabled');
    }
    if (!shouldUseBackup(backupMode)) {
      return Response(status: Status.canceled, error: 'backup unavailable');
    }
    final backup = await runOnBackup((source) {
      return source.get(
        params: params,
        countable: countable,
        resolveRefs: resolveRefs ?? createRefs,
        resolveDocChangesRefs: resolveDocChangesRefs,
        onlyUpdates: onlyUpdates,
        ignore: ignore,
      );
    });
    if (!backup.isValid) {
      return Response(status: backup.status, error: backup.error);
    }
    await _writeBackToPrimary(
      backup.result,
      params: params,
      createRefs: createRefs,
      merge: merge,
      useLazy: shouldUseLazy(lazyMode),
    );
    return Response(status: Status.ok);
  }
}
