import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_andomie/models/selection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_analytics/analytics.dart';

typedef DataCubitToggleAsyncCallback = Future<Response<bool>> Function();

abstract class DataCubit<T extends Object> extends Cubit<Response<T>> {
  // ---------------------------------------------------------------------------
  // -------------------------------CORE MODIFIER-------------------------------
  // ---------------------------------------------------------------------------

  DataCubit([Response<T>? initial]) : super(initial ?? Response());

  @override
  Future<void> close() async {
    super.close();
    _scheduledAsync?.cancel();
    _scheduledRefresh?.cancel();
    _scheduledStream?.cancel();
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

    if (identifier is T) return identifier;

    return null;
  }

  @protected
  List<T> put(T data, [int? index]) {
    final result = List<T>.from(state.result);
    if (index == null || index < 0 || index > result.length) {
      result.add(data);
      return result;
    }
    result.insert(index, data);
    return result;
  }

  /// identifier can be int, String, T
  @protected
  List<T> pop(Object identifier, {bool Function(T data)? test}) {
    if (identifier is int) {
      return List<T>.from(state.result)..removeAt(identifier);
    }
    if (identifier is String) {
      final index = indexOf(identifier, test);
      if (index == -1) return state.result;
      return List<T>.from(state.result)..removeAt(index);
    }
    if (identifier is T) {
      return List<T>.from(state.result)..remove(identifier);
    }
    return state.result;
  }

  @protected
  List<T> change(
    Object identifier,
    T Function(T) callback, {
    bool Function(T data)? test,
  }) {
    if (identifier is int) {
      if (identifier < 0 || identifier >= state.result.length) {
        return state.result;
      }
      final result = List<T>.from(state.result);
      final removed = result.removeAt(identifier);
      result.insert(identifier, callback(removed));
      return result;
    }
    if (identifier is String) {
      final index = indexOf(identifier, test);
      if (index == -1) return state.result;
      final result = List<T>.from(state.result);
      final removed = result.removeAt(index);
      result.insert(index, callback(removed));
      return result;
    }
    if (identifier is T) {
      final result = List<T>.from(state.result);
      final removed = result.remove(identifier);
      if (!removed) return result;
      final index = indexOf(identifier, test);
      if (index == -1) return result;
      result.insert(index, callback(identifier));
      return result;
    }
    return state.result;
  }

  // ---------------------------------------------------------------------------
  // -------------------------------STATE MODIFIER------------------------------
  // ---------------------------------------------------------------------------

  @protected
  Response<T> loading({bool force = false}) {
    if (force) return state.copyWith(status: Status.loading);
    if (state.status == Status.loading) return state;
    if (state.result.isEmpty) return state.copyWith(status: Status.loading);
    return state;
  }

  @protected
  Response<T> handle(
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
    if (!modifyState) return state;
    if (resultByMe) return state.copyWith(resultByMe: value.result);
    return state.copyWith(
      status: value.status,
      snapshot: value.snapshot,
      result: value.result,
    );
  }

  @protected
  Response<T> handleCount(
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
    if (!modifyState) return state;
    return state.copyWith(count: value);
  }

  @protected
  Response<T> handleError([
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
    if (!modifyState) return state;
    return state.copyWith(status: Status.error, error: error.toString());
  }

  @protected
  Response<T> handleCatchError([
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
    if (!modifyState) return state;
    return state.copyWith(status: Status.failure, error: error.toString());
  }

  Future<Response<T>> onFetch({
    bool loader = false,
    bool resultByMe = false,
    String? placement,
    int? initialSize,
    int? fetchingSize,
    Future<Response<T>> Function()? callback,
  }) async {
    placement ??= resultByMe ? "handleAsyncResultByMe" : "handleAsync";
    try {
      final x = loading(force: loader && !resultByMe);
      if (x != state) emit(x);
      return await (callback?.call() ??
              fetch(
                fetchingSize: fetchingSize,
                initialSize: initialSize,
                resultByMe: resultByMe,
              ))
          .then((e) => handle(e, resultByMe: resultByMe, placement: placement))
          .onError((e, st) => handleError(e, st, placement));
    } catch (e) {
      return handleCatchError(e, null, placement);
    }
  }

  Future<C> handleCustomAsync<C extends Object>(
    Future<C> Function() callback, {
    String? placement,
  }) async {
    placement ??= "handleCustomAsync<$C>";
    try {
      final feedback = await callback();
      handle(state, placement: placement, modifyState: false);
      return feedback;
    } catch (e) {
      handleCatchError(e, null, placement, false);
      rethrow;
    }
  }

  Future<Response<T>> handleAsyncCount({
    bool loader = false,
    String? placement,
    Future<Response<int>> Function()? callback,
  }) async {
    placement ??= "handleAsyncCount";
    try {
      final x = loading(force: loader);
      if (x != state) emit(x);
      return await (callback?.call() ?? count())
          .then((e) => handleCount(e.count, placement: placement))
          .onError((e, st) => handleError(e, st, placement));
    } catch (e) {
      return handleCatchError(e, null, placement);
    }
  }

  Future<bool> onRefresh({
    bool loader = false,
    bool resultByMe = false,
    String? placement,
    int? initialSize,
    int? fetchingSize,
  }) {
    placement ??= resultByMe ? "handleRefreshResultByMe" : "handleRefresh";
    return onFetch(
      loader: loader,
      resultByMe: resultByMe,
      placement: placement,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
    ).then((value) => value.isSuccessful);
  }

  Stream<Response<T>> handleStream({
    Stream<Response<T>> Function()? callback,
    String? placement,
    bool resultByMe = false,
    int? initialSize,
    int? fetchingSize,
  }) async* {
    placement ??= resultByMe ? "handleStreamResultByMe" : "handleStream";
    try {
      yield* (callback?.call() ??
              live(
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

  // ---------------------------------------------------------------------------
  // ----------------------------SCHEDULE FUNCTIONS-----------------------------
  // ---------------------------------------------------------------------------

  Timer? _scheduledAsync, _scheduledRefresh, _scheduledStream;

  void scheduledAsync({
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
      onFetch(
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
      onRefresh(
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
      handleStream(
        callback: callback,
        resultByMe: resultByMe,
        initialSize: initialSize,
        fetchingSize: fetchingSize,
      );
    });
  }

  // ---------------------------------------------------------------------------
  // ----------------------------INTERNAL FUNCTIONS-----------------------------
  // ---------------------------------------------------------------------------

  Future<bool> _like(Object? args) async {
    final data = createNewObject(args);
    if (data == null) return false;
    emit(
      state.copyWith(
        count: state.count + 1,
        result: state.result..insert(0, data),
        resultByMe: state.resultByMe..insert(0, data),
      ),
    );
    return handleCustomAsync(placement: "toggle:like", () {
      return create(data).then((value) {
        if (!value.isSuccessful) {
          emit(
            state.copyWith(
              count: state.count - 1,
              result: state.result..remove(data),
              resultByMe: state.resultByMe..remove(data),
            ),
          );
        }
        return value.isSuccessful;
      });
    });
  }

  Future<bool> _unlike(T data) async {
    emit(
      state.copyWith(
        count: state.count - 1,
        result: state.result..remove(data),
        resultByMe: state.resultByMe..remove(data),
      ),
    );
    return handleCustomAsync(placement: "toggle:unlike", () {
      return delete(data).then((value) {
        if (!value.isSuccessful) {
          emit(
            state.copyWith(
              count: state.count + 1,
              result: state.result..insert(0, data),
              resultByMe: state.resultByMe..insert(0, data),
            ),
          );
        }
        return value.isSuccessful;
      });
    });
  }

  Future<bool> toggle({int? index, bool? exist, Object? args}) {
    T? data;
    if (index != null) {
      data = state.result.elementAtOrNull(index);
    }
    data ??= state.resultByMe.firstOrNull;
    if (data != null) {
      return _unlike(data);
    } else {
      return _like(args);
    }
  }

  Future<bool> putAsync(T data, [int index = 0]) {
    emit(
      state.copyWith(
        count: state.count + 1,
        result: state.result..insert(0, data),
        resultByMe: state.resultByMe..insert(0, data),
      ),
    );
    return handleCustomAsync(placement: "putAsync", () {
      return create(data).then((value) {
        if (!value.isSuccessful) {
          emit(
            state.copyWith(
              count: state.count - 1,
              result: state.result..remove(data),
              resultByMe: state.resultByMe..remove(data),
            ),
          );
        }
        return value.isSuccessful;
      });
    });
  }

  Future<bool> popAsync(
    Object identifier, {
    bool Function(T data)? test,
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
    return handleCustomAsync(placement: "popAsync", () {
      return delete(data).then((value) {
        if (!value.isSuccessful) {
          emit(
            state.copyWith(
              count: state.count + 1,
              result: state.result..insert(0, data),
              resultByMe: state.resultByMe..insert(0, data),
            ),
          );
        }
        return value.isSuccessful;
      });
    });
  }

  // ---------------------------------------------------------------------------
  // -----------------------PROTECTED OVERRIDE FUNCTIONS------------------------
  // ---------------------------------------------------------------------------

  @protected
  T? createNewObject(Object? args) => null;

  @protected
  Future<Response<T>> create(T data) async {
    return Response(status: Status.undefined);
  }

  @protected
  Future<Response<T>> delete(T data) async {
    return Response(status: Status.undefined);
  }

  @protected
  Future<Response<T>> deleteById(String id) async {
    return Response(status: Status.undefined);
  }

  @protected
  Future<Response<int>> count() async {
    return Response(status: Status.undefined);
  }

  @protected
  Future<Response<T>> fetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) {
    throw Response(status: Status.undefined);
  }

  @protected
  Stream<Response<T>> live({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) {
    throw Response(status: Status.undefined);
  }

  // ---------------------------------------------------------------------------
  // -----------------------------GLOBAL FUNCTIONS------------------------------
  // ---------------------------------------------------------------------------

  Future<Response<T>> initial({
    bool force = false,
    bool resultByMe = false,
    int? initialSize,
    int? fetchingSize,
  }) async {
    if (!force && state.result.isNotEmpty && state.requestCode != 201) {
      return state;
    }
    return onFetch(
      placement: "initial",
      loader: force,
      resultByMe: resultByMe,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
    );
  }

  Future<Response<T>> initialCount({bool force = false}) async {
    if (!force &&
        state.data is num &&
        (state.data as num) > 0 &&
        state.requestCode != 201) {
      return state;
    }
    return handleAsyncCount(placement: "initialCount", callback: count);
  }

  /// created data by T and index
  void created(T data, [int? index]) {
    final result = put(data, index);
    emit(
      state.copyWith(result: result, requestCode: 201, count: result.length),
    );
  }

  /// deleted data by index, id, T
  void deleted(Object identifier, {bool Function(T data)? test}) {
    final result = pop(identifier, test: test);
    emit(
      state.copyWith(result: result, requestCode: 203, count: result.length),
    );
  }

  /// updated data by index, id, T
  void updated(
    Object identifier,
    T Function(T) callback, {
    bool Function(T data)? test,
  }) {
    emit(
      state.copyWith(
        result: change(identifier, callback, test: test),
        requestCode: 202,
      ),
    );
  }
}
