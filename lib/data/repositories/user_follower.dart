import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/user_follower.dart';
import '../sources/local/user_follower.dart';
import '../sources/remote/user_follower.dart';
import '../use_cases/user/get.dart';

class UserFollowerRepository extends RemoteDataRepository<UserFollower> {
  UserFollowerRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static UserFollowerRepository? _i;

  static UserFollowerRepository get i => _i ??= UserFollowerRepository(
    source: RemoteUserFollowerDataSource(),
    backup: LocalUserFollowerDataSource(database: InAppDatabase.i),
  );

  @override
  Future<Response<UserFollower>> getById(
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
  Future<Response<UserFollower>> getByIds(
    List<String> ids, {
    DataFieldParams? params,
    Object? args,
    bool? lazy,
    bool? cached,
  }) {
    return super.getByIds(ids, cached: cached, params: params).then(_modify);
  }

  @override
  Future<Response<UserFollower>> getByQuery({
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

  Future<Response<UserFollower>> _modify(
    Response<UserFollower> value, [
    bool singleMode = false,
  ]) async {
    if (value.isSuccessful) {
      if (singleMode) {
        return value.copy(data: await _value(value.data));
      } else {
        List<UserFollower> list = [];
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

  Future<UserFollower?> _value(UserFollower? i) async {
    if (i == null) return null;
    return GetUserUseCase.i(i.id).then((value) {
      return i.copy(user: value.data);
    });
  }
}
