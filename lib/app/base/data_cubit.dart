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
  void handle(
    Response<T> value, {
    bool resultByMe = false,
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
        "placement": placement ?? "handle",
      },
    );
    if (!modifyState) return;
    if (resultByMe) return emit(state.copyWith(resultByMe: value.result));
    return emit(
      state.copyWith(
        status: value.status,
        snapshot: value.snapshot,
        result: value.result,
      ),
    );
  }

  @protected
  void handleCount(int value, {String? placement, bool modifyState = true}) {
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
    if (!modifyState) return;
    return emit(state.copyWith(count: value));
  }

  @protected
  void handleError([
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
    if (!modifyState) return;
    return emit(state.copyWith(status: Status.error, error: error.toString()));
  }

  @protected
  void handleCatchError([
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
    if (!modifyState) return;
    return emit(
      state.copyWith(status: Status.failure, error: error.toString()),
    );
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
      handle(state, placement: placement, modifyState: false);
      return feedback;
    } catch (e) {
      handleCatchError(e, null, placement, false);
      rethrow;
    }
  }

  Future<void> load({
    bool force = false,
    bool resultByMe = false,
    int? initialSize,
    int? fetchingSize,
  }) async {
    if (!force && state.result.isNotEmpty && state.requestCode != 201) {
      return;
    }
    fetch(
      placement: "initial",
      loader: force,
      resultByMe: resultByMe,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
    );
  }

  Future<void> loadCounter({bool force = false}) async {
    if (!force &&
        state.data is num &&
        (state.data as num) > 0 &&
        state.requestCode != 201) {
      return;
    }
    count(placement: "initialCount");
  }

  // ---------------------------------------------------------------------------
  // ------------------------------READ FUNCTIONS-------------------------------
  // ---------------------------------------------------------------------------

  Future<int> count({
    bool loader = false,
    String? placement,
    Future<Response<int>> Function()? callback,
  }) async {
    placement ??= "count";
    try {
      loading(force: loader);
      await (callback?.call() ?? onCount())
          .then((e) => handleCount(e.data ?? 0, placement: placement))
          .onError((e, st) => handleError(e, st, placement));
      return state.count;
    } catch (e) {
      handleCatchError(e, null, placement);
      return state.count;
    }
  }

  Future<Response<T>> fetch({
    bool loader = false,
    bool resultByMe = false,
    String? placement,
    int? initialSize,
    int? fetchingSize,
    Future<Response<T>> Function()? callback,
  }) async {
    placement ??= resultByMe ? "fetchResultByMe" : "fetch";
    try {
      loading(force: loader && !resultByMe);
      return await (callback?.call() ??
              onFetch(
                fetchingSize: fetchingSize,
                initialSize: initialSize,
                resultByMe: resultByMe,
              ))
          .then((e) => handle(e, resultByMe: resultByMe, placement: placement))
          .onError((e, st) => handleError(e, st, placement))
          .then((_) => state);
    } catch (e) {
      handleCatchError(e, null, placement);
      return state;
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
          .handleError((e, st) => handleError(e, st, placement))
          .map((_) => state);
    } catch (e) {
      handleCatchError(e, null, placement);
    }
  }

  Future<bool> refresh({
    bool loader = false,
    bool resultByMe = false,
    String? placement,
    int? initialSize,
    int? fetchingSize,
  }) {
    placement ??= resultByMe ? "refreshResultByMe" : "refresh";
    return fetch(
      loader: loader,
      resultByMe: resultByMe,
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
    int index = 0,
    String? placement,
    T Function(T)? replace,
    VoidCallback? onPut,
    VoidCallback? onCreated,
    VoidCallback? onFailed,
  }) {
    emit(
      state.copyWith(
        count: state.count + 1,
        result: state.result..insert(0, data),
        resultByMe: state.resultByMe..insert(0, data),
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

  Future<bool> toggle({
    int? index,
    bool? exist,
    Object? args,
    String? placement,
    T Function(T)? replace,
    VoidCallback? onPut,
    VoidCallback? onPop,
    ValueChanged<bool>? onToggled,
    ValueChanged<bool>? onFailed,
  }) async {
    T? data;
    if (index != null) {
      data = state.result.elementAtOrNull(index);
    }
    data ??= state.resultByMe.firstOrNull;

    if (data != null) {
      return delete(
        data,
        placement: placement ?? "toggle:delete",
        replace: replace,
        onPop: onPop,
        onDeleted: onToggled != null ? () => onToggled(false) : null,
        onFailed: onFailed != null ? () => onFailed(false) : null,
      );
    } else {
      final data = createNewObject(args);
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
    return execute(placement: placement ?? "update", () {
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
