import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

abstract class DataCubit<T extends Object> extends Cubit<Response<T>> {
  DataCubit() : super(Response());

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

  List<T> remove(String id) {
    final result = state.result;
    final index = indexOf(id);
    result.removeAt(index);
    return result;
  }

  void fetch() {}

  void live() {}

  void insert(BuildContext context, T data) {}

  void delete(BuildContext context, String id) {}

  void update(BuildContext context, String id, Map<String, dynamic> updates) {}
}
