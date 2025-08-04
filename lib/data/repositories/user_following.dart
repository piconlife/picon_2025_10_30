import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/user_following.dart';
import '../sources/local/user_following.dart';
import '../sources/remote/user_following.dart';
import '../use_cases/user/get.dart';

class UserFollowingRepository extends RemoteDataRepository<UserFollowing> {
  UserFollowingRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static UserFollowingRepository? _i;

  static UserFollowingRepository get i => _i ??= UserFollowingRepository(
    source: RemoteUserFollowingDataSource(),
    backup: LocalUserFollowingDataSource(database: InAppDatabase.i),
  );

  @override
  Future<Response<UserFollowing>> getById(
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
  Future<Response<UserFollowing>> getByIds(
    List<String> ids, {
    DataFieldParams? params,
    Object? args,
    bool? lazy,
    bool? cached,
  }) {
    return super.getByIds(ids, cached: cached, params: params).then(_modify);
  }

  @override
  Future<Response<UserFollowing>> getByQuery({
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

  Future<Response<UserFollowing>> _modify(
    Response<UserFollowing> value, [
    bool singleMode = false,
  ]) async {
    if (value.isSuccessful) {
      if (singleMode) {
        return value.copy(data: await _value(value.data));
      } else {
        List<UserFollowing> list = [];
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

  Future<UserFollowing?> _value(UserFollowing? i) async {
    if (i == null) return null;
    return GetUserUseCase.i(i.id).then((value) {
      return i.copy(user: value.data);
    });
  }
}
