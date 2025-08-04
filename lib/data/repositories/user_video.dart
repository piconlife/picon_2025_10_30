import 'package:data_management/core.dart';
import 'package:flutter_andomie/core.dart' hide Selection;
import 'package:flutter_entity/entity.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/user_video.dart';
import '../sources/local/user_video.dart';
import '../sources/remote/user_video.dart';
import '../use_cases/feed_video/get.dart';

class UserVideoRepository extends RemoteDataRepository<UserVideo> {
  UserVideoRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static UserVideoRepository? _i;

  static UserVideoRepository get i => _i ??= UserVideoRepository(
    source: RemoteUserVideoDataSource(),
    backup: LocalUserVideoDataSource(database: InAppDatabase.i),
  );

  @override
  Future<Response<UserVideo>> get({
    DataFieldParams? params,
    Object? args,
    bool? lazy,
    bool? cached,
  }) {
    return super.get(cached: cached, params: params).then(_modify);
  }

  @override
  Future<Response<UserVideo>> getById(
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
  Future<Response<UserVideo>> getByIds(
    List<String> ids, {
    DataFieldParams? params,
    Object? args,
    bool? lazy,
    bool? cached,
  }) {
    return super.getByIds(ids, cached: cached, params: params).then(_modify);
  }

  @override
  Future<Response<UserVideo>> getByQuery({
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

  Future<Response<UserVideo>> _modify(
    Response<UserVideo> value, [
    bool singleMode = false,
  ]) async {
    if (value.isSuccessful) {
      if (singleMode) {
        return value.copy(data: await _value(value.data));
      } else {
        List<UserVideo> list = [];
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

  Future<UserVideo?> _value(UserVideo? i) async {
    if (i != null) {
      return GetVideosUseCase.i(i.path.use).then((value) {
        return i.withUserVideo(videos: value.result);
      });
    }
    return i;
  }
}
