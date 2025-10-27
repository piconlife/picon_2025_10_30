import 'dart:async';

import 'package:flutter_andomie/models/selection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

abstract class DataCubit<T extends Object> extends Cubit<Response<T>> {
  DataCubit() : super(Response());

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
    if (index < 0 || index >= state.result.length) return null;
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

  void created(T value) {
    final x = List<T>.from(state.result);
    x.insert(0, value);
    emit(state.copyWith(result: x, requestCode: 201, count: x.length));
  }

  void updated(T value) {
    final index = state.result.indexOf(value);
    if (index >= 0) {
      state.result.removeAt(index);
      state.result.insert(index, value);
      emit(state.copyWith(data: value, result: state.result, requestCode: 202));
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
