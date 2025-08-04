import 'package:data_management/core.dart';
import 'package:flutter_andomie/core.dart' hide Selection;
import 'package:flutter_entity/entity.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/user_post.dart';
import '../sources/local/user_post.dart';
import '../sources/remote/user_post.dart';
import '../use_cases/photo/get.dart';

class UserPostRepository extends RemoteDataRepository<UserPost> {
  UserPostRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static UserPostRepository? _i;

  static UserPostRepository get i => _i ??= UserPostRepository(
    source: RemoteUserPostDataSource(),
    backup: LocalUserPostDataSource(database: InAppDatabase.i),
  );

  @override
  Future<Response<UserPost>> get({
    DataFieldParams? params,
    Object? args,
    bool? lazy,
    bool? cached,
  }) {
    return super.get(cached: cached, params: params).then(_modify);
  }

  @override
  Future<Response<UserPost>> getById(
    String id, {
    DataFieldParams? params,
    Object? args,
    bool? lazy,
    bool? cached,
  }) {
    return super
        .getById(id, cached: cached, params: params)
        .then((v) => _modify(v, true));
  }

  @override
  Future<Response<UserPost>> getByIds(
    List<String> ids, {
    DataFieldParams? params,
    Object? args,
    bool? lazy,
    bool? cached,
  }) {
    return super.getByIds(ids, cached: cached, params: params).then(_modify);
  }

  @override
  Future<Response<UserPost>> getByQuery({
    DataFieldParams? params,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
    Object? args,
    bool? lazy,
    bool? cached,
  }) {
    return super
        .getByQuery(
          cached: cached,
          params: params,
          queries: queries,
          selections: selections,
          sorts: sorts,
          options: options,
        )
        .then(_modify);
  }

  Future<Response<UserPost>> _modify(
    Response<UserPost> value, [
    bool singleMode = false,
  ]) async {
    if (value.isSuccessful) {
      if (singleMode) {
        return value.copy(data: await _value(value.data));
      } else {
        List<UserPost> list = [];
        for (var i in value.result) {
          final data = await _value(i);
          if (data != null) list.add(data);
        }
        return value.copy(result: list);
      }
    } else {
      return value;
    }
  }

  Future<UserPost?> _value(UserPost? i) async {
    if (i == null) return i;
    if (i.isPhotoMode) {
      final value = await GetPhotosUseCase.i(i.path.use);
      if (value.isValid) i = i..photos = value.result;
    }
    return i;
  }
}
