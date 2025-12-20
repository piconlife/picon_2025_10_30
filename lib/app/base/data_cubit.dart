import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_andomie/models/selection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_analytics/analytics.dart';

typedef DataCubitToggleAsyncCallback = Future<Response<bool>> Function();

abstract class DataCubit<T extends Object> extends Cubit<Response<T>> {
  // ---------------------------------------------------------------------------
  // ----------------------------------CORE-------------------------------------
  // ---------------------------------------------------------------------------

  BuildContext context;

  DataCubit(this.context, [Response<T>? initial])
    : super(initial ?? Response());

  static C of<C extends DataCubit>(BuildContext context) => context.read<C>();

  @override
  Future<void> close() async {
    super.close();
    _scheduledAsync?.cancel();
    _scheduledRefresh?.cancel();
    _scheduledStream?.cancel();
  }

  // ---------------------------------------------------------------------------
  // ---------------------------------MODIFIER----------------------------------
  // ---------------------------------------------------------------------------

  bool add(T data, [int? index]) {
    if (index == null || index < 0 || index > state.result.length) {
      emit(
        state.copyWith(
          count: state.count + 1,
          result: state.result..add(data),
          resultByMe: state.resultByMe..add(data),
        ),
      );
      return true;
    }
    emit(
      state.copyWith(
        count: state.count + 1,
        result: state.result..insert(0, data),
        resultByMe: state.resultByMe..insert(0, data),
      ),
    );
    return true;
  }

  bool remove(Object identifier, {bool Function(T data)? test}) {
    if (identifier is int) {
      emit(
        state.copyWith(
          count: state.count - 1,
          result: state.result..removeAt(identifier),
          resultByMe: state.resultByMe..removeAt(identifier),
        ),
      );
      return true;
    }
    if (identifier is String) {
      final index = indexOf(identifier, test);
      if (index == -1) return false;
      emit(
        state.copyWith(
          count: state.count - 1,
          result: state.result..removeAt(index),
          resultByMe: state.resultByMe..removeAt(index),
        ),
      );
      return true;
    }
    if (identifier is T) {
      emit(
        state.copyWith(
          count: state.count - 1,
          result: state.result..remove(identifier),
          resultByMe: state.resultByMe..remove(identifier),
        ),
      );
      return true;
    }
    return false;
  }

  bool replace(
    Object identifier,
    T Function(T) callback, {
    bool Function(T data)? test,
  }) {
    if (identifier is int) {
      if (identifier < 0 || identifier >= state.result.length) {
        return false;
      }
      final result = List<T>.from(state.result);
      final removed = result.removeAt(identifier);
      result.insert(identifier, callback(removed));
      emit(state.copyWith(result: result));
      return true;
    }
    if (identifier is String) {
      final index = indexOf(identifier, test);
      if (index == -1) return false;
      final result = List<T>.from(state.result);
      final removed = result.removeAt(index);
      result.insert(index, callback(removed));
      emit(state.copyWith(result: result));
      return true;
    }
    if (identifier is T) {
      final result = List<T>.from(state.result);
      final removed = result.remove(identifier);
      if (!removed) return false;
      final index = indexOf(identifier, test);
      if (index == -1) return false;
      result.insert(index, callback(identifier));
      emit(state.copyWith(result: result));
      return true;
    }
    return false;
  }

  // ---------------------------------------------------------------------------
  // ------------------------------CONTENT MODIFIER-----------------------------
  // ---------------------------------------------------------------------------

  bool isExist(Object identifier, {bool Function(String id, T data)? test}) {
    if (identifier is Entity) {
      identifier = identifier.id;
    } else if (identifier is Selection) {
      identifier = identifier.id;
    }
    if (identifier is T) {
      if (state.resultByMe.contains(identifier)) return true;
      if (state.result.contains(identifier)) return true;
    }
    if (identifier is! String || identifier.isEmpty) return false;
    return state.result.any((e) {
      if (e is Entity) return e.id == identifier;
      if (e is Selection) return e.id == identifier;
      if (test != null) return test(identifier as String, e);
      return false;
    });
  }

  int indexOf(Object? identifier, [bool Function(T data)? test]) {
    if (identifier == null) return -1;
    final result = state.result;
    if (identifier is T) return result.indexOf(identifier);
    if (identifier is int && identifier >= 0 && identifier < result.length) {
      return identifier;
    }
    if (identifier is String && identifier.isNotEmpty) {
      return result.indexWhere((e) {
        if (e is Entity) return e.id == identifier;
        if (e is Selection) return e.id == identifier;
        if (test != null) return test(e);
        return false;
      });
    }

    return -1;
  }

  T elementOf(Object? identifier, [bool Function(T data)? test]) {
    final data = elementOfOrNull(identifier, test);
    if (data != null) return data;
    throw Exception("Data not found");
  }

  T? elementOfOrNull(Object? identifier, [bool Function(T data)? test]) {
    if (identifier is T) return identifier;
    if (identifier == null || state.result.isEmpty) return null;
    final result = state.result;
    if (identifier is int && identifier >= 0 && identifier < result.length) {
      return result[identifier];
    }
    if (identifier is String && identifier.isNotEmpty) {
      try {
        return state.result.firstWhere((e) {
          if (e is Entity && e.id == identifier) return true;
          if (e is Selection && e.id == identifier) return true;
          if (test != null) return test(e);
          return false;
        });
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // -------------------------------STATE MODIFIER------------------------------
  // ---------------------------------------------------------------------------

  @protected
  void loading({bool force = false}) {
    if (force) return emit(state.copyWith(status: Status.loading));
    if (state.status == Status.loading) return;
    if (state.result.isEmpty) {
      return emit(state.copyWith(status: Status.loading));
    }
  }

  @protected
  Response<T> handle(
    Response<T> value, {
    String? placement,
    bool resultByMe = false,
    bool keepIds = false,
    bool modifyState = true,
  }) {
    Analytics.event(
      "data_cubit",
      reason: "ok",
      status: true,
      props: {
        "contentType": T.runtimeType.toString(),
        "cubitName": runtimeType.toString(),
        "placement": placement ?? "handle",
      },
    );
    if (!modifyState) return value;
    if (resultByMe) {
      emit(
        state.copyWith(
          resultByMe: {...state.resultByMe, ...value.result}.toList(),
        ),
      );
      return value;
    }
    emit(
      state.copyWith(
        status: value.status,
        snapshot: value.snapshot,
        result: {...state.result, ...value.result}.toList(),
        exists: keepIds ? {...state.exists, ...value.exists} : null,
      ),
    );
    return value;
  }

  @protected
  Response<int> handleCount(
    int value, {
    String? placement,
    bool modifyState = true,
  }) {
    Analytics.event(
      "data_cubit",
      reason: "ok",
      status: true,
      props: {
        "contentType": T.runtimeType.toString(),
        "cubitName": runtimeType.toString(),
        "placement": placement ?? "handleCount",
      },
    );
    if (!modifyState) return Response(data: value);
    emit(state.copyWith(count: value));
    return Response(data: value);
  }

  @protected
  Response<C> handleError<C extends Object>([
    Object? error,
    StackTrace? stackTrace,
    String? placement,
    bool modifyState = true,
  ]) {
    Analytics.event(
      "data_cubit",
      reason: "error",
      status: false,
      props: {
        "contentType": T.runtimeType.toString(),
        "cubitName": runtimeType.toString(),
        "error": error.toString(),
        "placement": placement ?? "handleError",
        if (stackTrace != null) "stackTrace": stackTrace.toString(),
      },
    );
    if (!modifyState) return Response.failure(error);
    emit(state.copyWith(status: Status.error, error: error.toString()));
    return Response.failure(error);
  }

  @protected
  Response<C> handleCatchError<C extends Object>([
    Object? error,
    StackTrace? stackTrace,
    String? placement,
    bool modifyState = true,
  ]) {
    Analytics.event(
      "data_cubit",
      reason: "failure",
      status: false,
      props: {
        "contentType": T.runtimeType.toString(),
        "cubitName": runtimeType.toString(),
        "error": error.toString(),
        "placement": placement ?? "handleCatchError",
        if (stackTrace != null) "stackTrace": stackTrace.toString(),
      },
    );
    if (!modifyState) return Response.failure(error);
    emit(state.copyWith(status: Status.failure, error: error.toString()));
    return Response.failure(error);
  }

  // ---------------------------------------------------------------------------
  // ----------------------------EXTERNAL FUNCTIONS-----------------------------
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // -----------------------------CUSTOM FUNCTIONS------------------------------
  // ---------------------------------------------------------------------------

  Future<C> execute<C extends Object>(
    Future<C> Function() callback, {
    String? placement,
  }) async {
    placement ??= "execute<$C>";
    try {
      final feedback = await callback();
      return feedback;
    } catch (e) {
      handleCatchError(e, null, placement, false);
      rethrow;
    }
  }

  Future<Response<T>> load({
    bool force = false,
    bool resultByMe = false,
    bool keepIds = false,
    int? initialSize,
    int? fetchingSize,
  }) async {
    if (!force && state.result.isNotEmpty && state.requestCode != 201) {
      return Response(status: Status.invalid);
    }
    return fetch(
      placement: "initial",
      loader: force,
      resultByMe: resultByMe,
      keepIds: keepIds,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
    );
  }

  Future<Response<int>> loadCounter({bool force = false}) async {
    if (!force &&
        state.data is num &&
        (state.data as num) > 0 &&
        state.requestCode != 201) {
      return Response(status: Status.invalid);
    }
    return count(placement: "initialCount");
  }

  // ---------------------------------------------------------------------------
  // ------------------------------READ FUNCTIONS-------------------------------
  // ---------------------------------------------------------------------------

  Future<Response<int>> count({
    bool loader = false,
    String? placement,
    Future<Response<int>> Function()? callback,
  }) async {
    placement ??= "count";
    try {
      loading(force: loader);
      final x = await (callback?.call() ?? onCount())
          .then((e) => handleCount(e.data ?? 0, placement: placement))
          .onError((e, st) => handleError(e, st, placement));
      return x;
    } catch (e) {
      return handleCatchError(e, null, placement);
    }
  }

  Future<Response<T>> fetch({
    bool loader = false,
    bool resultByMe = false,
    bool keepIds = false,
    String? placement,
    int? initialSize,
    int? fetchingSize,
    Future<Response<T>> Function()? callback,
  }) async {
    placement ??= resultByMe ? "fetchResultByMe" : "fetch";
    try {
      loading(force: loader && !resultByMe);
      final x = await (callback?.call() ??
              onFetch(
                fetchingSize: fetchingSize,
                initialSize: initialSize,
                resultByMe: resultByMe,
              ))
          .then((e) {
            return handle(
              e,
              resultByMe: resultByMe,
              keepIds: keepIds,
              placement: placement,
            );
          })
          .onError((e, st) => handleError(e, st, placement));
      return x;
    } catch (e) {
      return handleCatchError(e, null, placement);
    }
  }

  Stream<Response<T>> listen({
    Stream<Response<T>> Function()? callback,
    String? placement,
    bool resultByMe = false,
    int? initialSize,
    int? fetchingSize,
  }) async* {
    placement ??= resultByMe ? "listenResultByMe" : "listen";
    try {
      yield* (callback?.call() ??
              onStream(
                resultByMe: resultByMe,
                fetchingSize: fetchingSize,
                initialSize: initialSize,
              ))
          .map((e) => handle(e, resultByMe: resultByMe, placement: placement))
          .handleError((e, st) => handleError(e, st, placement));
    } catch (e) {
      yield handleCatchError(e, null, placement);
    }
  }

  Future<bool> refresh({
    bool loader = false,
    bool resultByMe = false,
    bool keepIds = false,
    String? placement,
    int? initialSize,
    int? fetchingSize,
  }) {
    placement ??= resultByMe ? "refreshResultByMe" : "refresh";
    return fetch(
      loader: loader,
      resultByMe: resultByMe,
      keepIds: keepIds,
      placement: placement,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
    ).then((value) => value.isSuccessful);
  }

  // ---------------------------------------------------------------------------
  // ------------------------------WRITE FUNCTIONS------------------------------
  // ---------------------------------------------------------------------------

  Future<bool> create(
    T data, {
    int? index = 0,
    String? placement,
    T Function(T)? replace,
    VoidCallback? onPut,
    VoidCallback? onCreated,
    VoidCallback? onFailed,
  }) {
    emit(
      state.copyWith(
        count: state.count + 1,
        result:
            index != null
                ? (state.result..insert(index, data))
                : (state.result..add(data)),
        resultByMe:
            index != null
                ? (state.resultByMe..insert(index, data))
                : (state.resultByMe..add(data)),
      ),
    );
    onPut?.call();
    return execute(placement: placement ?? "create[$T]", () {
      return onCreate(data).then((value) {
        if (!value.isSuccessful) {
          emit(
            state.copyWith(
              count: state.count - 1,
              result: state.result..remove(data),
              resultByMe: state.resultByMe..remove(data),
            ),
          );
          onFailed?.call();
        } else {
          if (replace != null) this.replace(data, replace);
          onCreated?.call();
        }
        return value.isSuccessful;
      });
    });
  }

  final Set<String> _pending = {};

  /// Manual override (use on follow/unfollow)
  void setExist(String id, bool value) {
    final exists = Map<String, bool>.of(state.exists);
    exists[id] = value;
    emit(state.copyWith(exists: exists));
  }

  /// Clear cache (logout)
  void clear() => emit(Response());

  Future<bool> exist(String identifier, {String? placement}) async {
    if (state.exists.containsKey(identifier)) {
      return state.exists[identifier]!;
    }

    if (_pending.contains(identifier)) {
      return false;
    }

    _pending.add(identifier);

    try {
      final value = await onGetById(identifier);

      final exists = Map<String, bool>.of(state.exists);
      final isExist = value.isSuccessful && value.data != null;

      exists[identifier] = isExist;
      _pending.remove(identifier);

      emit(state.copyWith(exists: exists));
      return isExist;
    } finally {
      _pending.remove(identifier);
    }
  }

  Future<bool> delete(
    Object identifier, {
    String? placement,
    T Function(T)? replace,
    bool Function(T data)? test,
    VoidCallback? onPop,
    VoidCallback? onDeleted,
    VoidCallback? onFailed,
  }) async {
    T? data = elementOfOrNull(identifier, test);
    if (data == null) return false;
    emit(
      state.copyWith(
        count: state.count - 1,
        result: state.result..remove(data),
        resultByMe: state.resultByMe..remove(data),
      ),
    );
    onPop?.call();
    return execute(placement: placement ?? "delete", () {
      return onDelete(data).then((value) {
        if (!value.isSuccessful) {
          emit(
            state.copyWith(
              count: state.count + 1,
              result: state.result..insert(0, data),
              resultByMe: state.resultByMe..insert(0, data),
            ),
          );
          onFailed?.call();
        } else {
          if (replace != null) this.replace(data, replace);
          onDeleted?.call();
        }
        return value.isSuccessful;
      });
    });
  }

  Future<bool> seen(
    T data, {
    int index = 0,
    String? placement,
    T Function(T)? replace,
    VoidCallback? onPut,
    VoidCallback? onDone,
    VoidCallback? onFailed,
  }) {
    if (isExist(data)) return Future.value(false);
    emit(
      state.copyWith(
        count: state.count + 1,
        result: state.result..insert(index, data),
        resultByMe: state.resultByMe..insert(index, data),
      ),
    );
    onPut?.call();
    return execute(placement: placement ?? "seen[$T]", () {
      return onCreateIfNotExist(data).then((value) {
        if (!value.isSuccessful) {
          emit(
            state.copyWith(
              count: state.count - 1,
              result: state.result..remove(data),
              resultByMe: state.resultByMe..remove(data),
            ),
          );
          onFailed?.call();
        } else {
          if (replace != null) this.replace(data, replace);
          onDone?.call();
        }
        return value.isSuccessful;
      });
    });
  }

  Future<bool> toggle({
    int? index,
    bool? exist,
    T? data,
    Object? args,
    String? placement,
    T Function(T)? replace,
    VoidCallback? onPut,
    VoidCallback? onPop,
    ValueChanged<bool>? onToggled,
    ValueChanged<bool>? onFailed,
  }) async {
    if (index != null) data ??= state.result.elementAtOrNull(index);
    data ??= state.resultByMe.firstOrNull;
    if (data != null && (exist == null || exist)) {
      return delete(
        data,
        placement: placement ?? "toggle:delete",
        replace: replace,
        onPop: onPop,
        onDeleted: onToggled != null ? () => onToggled(false) : null,
        onFailed: onFailed != null ? () => onFailed(false) : null,
      );
    } else {
      data ??= createNewObject(args);
      if (data == null) return false;
      return create(
        data,
        placement: placement ?? "toggle:create",
        replace: replace,
        onPut: onPut,
        onCreated: onToggled != null ? () => onToggled(true) : null,
        onFailed: onFailed != null ? () => onFailed(true) : null,
      );
    }
  }

  Future<bool> update(
    Object identifier,
    Map<String, dynamic> changes, {
    Map<String, dynamic> deletes = const {},
    required T Function(T, bool) modifier,
    String? placement,
    VoidCallback? onUpdated,
    VoidCallback? onReplaced,
    VoidCallback? onFailed,
    bool Function(T data)? test,
  }) async {
    final old = elementOfOrNull(identifier, test);
    if (old == null) return false;
    replace(old, (e) => modifier(e, false));
    onReplaced?.call();
    return execute(placement: placement ?? "update", () async {
      if (deletes.isNotEmpty) {
        await onUpdate(old, deletes);
      }
      return onUpdate(old, changes).then((value) {
        if (value.isSuccessful) {
          replace(identifier, (e) => modifier(e, true));
          onUpdated?.call();
        } else {
          replace(identifier, (e) => old);
          onFailed?.call();
        }
        return value.isSuccessful;
      });
    });
  }

  // ---------------------------------------------------------------------------
  // ----------------------------SCHEDULE FUNCTIONS-----------------------------
  // ---------------------------------------------------------------------------

  Timer? _scheduledAsync, _scheduledRefresh, _scheduledStream;

  void scheduledFetch({
    Future<Response<T>> Function()? callback,
    String? placement,
    Duration duration = const Duration(milliseconds: 100),
    bool loader = false,
    bool resultByMe = false,
    bool keepIds = false,
    int? initialSize,
    int? fetchingSize,
  }) {
    placement ??= resultByMe ? "scheduledAsyncResultByMe" : "scheduledAsync";
    _scheduledAsync?.cancel();
    _scheduledAsync = Timer(duration, () {
      _scheduledAsync?.cancel();
      fetch(
        callback: callback,
        loader: loader,
        resultByMe: resultByMe,
        keepIds: keepIds,
        placement: placement,
        fetchingSize: fetchingSize,
        initialSize: initialSize,
      );
    });
  }

  void scheduledRefresh({
    String? placement,
    Duration duration = const Duration(minutes: 15),
    bool loader = false,
    bool resultByMe = false,
    int? initialSize,
    int? fetchingSize,
  }) {
    placement ??=
        resultByMe ? "scheduledRefreshResultByMe" : "scheduledRefresh";
    _scheduledRefresh?.cancel();
    _scheduledRefresh = Timer.periodic(duration, (_) {
      refresh(
        loader: loader,
        resultByMe: resultByMe,
        initialSize: initialSize,
        fetchingSize: fetchingSize,
      );
    });
  }

  void scheduledStream({
    String? placement,
    Stream<Response<T>> Function()? callback,
    Duration duration = const Duration(seconds: 15),
    bool resultByMe = false,
    int? initialSize,
    int? fetchingSize,
  }) {
    placement ??= resultByMe ? "scheduledStreamResultByMe" : "scheduledStream";
    _scheduledStream?.cancel();
    _scheduledStream = Timer(duration, () {
      _scheduledStream?.cancel();
      listen(
        callback: callback,
        resultByMe: resultByMe,
        initialSize: initialSize,
        fetchingSize: fetchingSize,
      );
    });
  }

  // ---------------------------------------------------------------------------
  // -----------------------PROTECTED OVERRIDE FUNCTIONS------------------------
  // ---------------------------------------------------------------------------

  @protected
  T? createNewObject(Object? args) => null;

  @protected
  Future<Response<T>> onCreateIfNotExist(T data) async {
    return Response(status: Status.undefined);
  }

  @protected
  Future<Response<int>> onCount() async {
    return Response(status: Status.undefined);
  }

  @protected
  Future<Response<T>> onCreate(T data) async {
    return Response(status: Status.undefined);
  }

  @protected
  Future<Response<T>> onDelete(T data) async {
    return Response(status: Status.undefined);
  }

  @protected
  Future<Response<T>> onDeleteById(String id) async {
    return Response(status: Status.undefined);
  }

  @protected
  Future<Response<T>> onGetById(String id) async {
    return Response(status: Status.undefined);
  }

  @protected
  Future<Response<T>> onUpdate(T old, Map<String, dynamic> changes) async {
    return Response(status: Status.undefined);
  }

  @protected
  Future<Response<T>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) {
    throw Response(status: Status.undefined);
  }

  @protected
  Stream<Response<T>> onStream({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) {
    throw Response(status: Status.undefined);
  }
}
