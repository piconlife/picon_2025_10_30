import 'dart:async';

import 'package:flutter_andomie/models/selection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

typedef DataCubitToggleAsyncCallback = Future<Response<bool>> Function();

abstract class DataCubit<T extends Object> extends Cubit<Response<T>> {
  DataCubit([Response<T>? initial]) : super(initial ?? Response());

  Timer? _timer;

  void initial() {
    if (state.result.isNotEmpty && state.requestCode != 201) return;
    fetch();
  }

  void initialCount() {
    if (state.data is num &&
        (state.data as num) > 0 &&
        state.requestCode != 201) {
      return;
    }
    count();
  }

  void refresh() => fetch();

  void execute(Function() callback) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 100), () {
      _timer?.cancel();
      callback();
    });
  }

  int indexOf(String? id, [String Function(T data)? finder]) {
    if (id == null || id.isEmpty) return -1;
    return state.result.indexWhere((e) {
      if (finder != null) return finder(e) == id;
      if (e is Entity) return e.id == id;
      if (e is Selection) return e.id == id;
      return false;
    });
  }

  T? elementOf(String? id, [int? index]) {
    index ??= indexOf(id);
    if (index < 0 || index >= state.result.length) {
      try {
        return state.result.firstWhere((e) {
          if (e is Entity && e.id == id) return true;
          if (e is Selection && e.id == id) return true;
          return false;
        });
      } catch (_) {
        return null;
      }
    }
    return state.result.elementAtOrNull(index);
  }

  List<T> put(T data, [int? index]) {
    final result = state.result;
    if (index == null || index < 0 || index > result.length) {
      result.add(data);
      return result;
    }
    result.insert(index, data);
    return result;
  }

  List<T> pop(String? id, [String Function(T data)? finder]) {
    final index = indexOf(id, finder);
    return state.result..removeAt(index);
  }

  List<T> change(String id, T Function(T) callback) {
    final result = state.result;
    final index = indexOf(id);
    final data = result.removeAt(index);
    result.insert(index, callback(data));
    return result;
  }

  void toggle({int? index, bool? exist, Object? args}) {
    T? data;
    if (index != null) {
      data = state.result.elementAtOrNull(index);
    }
    data ??= state.resultByMe.firstOrNull;
    if (data != null) {
      _unlike(data);
    } else {
      _like(args);
    }
  }

  void _like(Object? args) {
    final data = createNewObject(args);
    if (data == null) return;
    emit(
      state.copyWith(
        count: state.count + 1,
        result: state.result..insert(0, data),
        resultByMe: state.resultByMe..insert(0, data),
      ),
    );
    onCreateByData(data).then((value) {
      if (!value) {
        emit(
          state.copyWith(
            count: state.count - 1,
            result: state.result..remove(data),
            resultByMe: state.resultByMe..remove(data),
          ),
        );
      }
      return value;
    });
  }

  void _unlike(T data) {
    emit(
      state.copyWith(
        count: state.count - 1,
        result: state.result..remove(data),
        resultByMe: state.resultByMe..remove(data),
      ),
    );
    onDeleteByData(data).then((value) {
      if (!value) {
        emit(
          state.copyWith(
            count: state.count + 1,
            result: state.result..insert(0, data),
            resultByMe: state.resultByMe..insert(0, data),
          ),
        );
      }
      return value;
    });
  }

  T? createNewObject(Object? args) => null;

  Future<bool> onCreateByData(T data) async => true;

  Future<bool> onDeleteByData(T data) async => true;

  Future<bool> onDeleteById(String id) async => true;

  void created(T value) {
    state.result.insert(0, value);
    emit(
      state.copyWith(
        result: state.result,
        requestCode: 201,
        count: state.result.length,
      ),
    );
  }

  void updatedAt(int index, T value) {
    if (index >= 0 && state.result.length > index) {
      state.result.removeAt(index);
      state.result.insert(index, value);
      emit(state.copyWith(result: state.result, requestCode: 202));
    }
  }

  List<T> remove(String id) {
    final result = state.result;
    final index = indexOf(id);
    result.removeAt(index);
    return result;
  }

  void count() {}

  void fetch() {}

  void live() {}

  @override
  Future<void> close() async {
    super.close();
    _timer?.cancel();
  }
}
