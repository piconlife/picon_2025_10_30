import 'package:data_management/core.dart';
import 'package:flutter_andomie/core.dart' hide Selection;
import 'package:flutter_entity/entity.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/user_note.dart';
import '../sources/local/user_note.dart';
import '../sources/remote/user_note.dart';
import '../use_cases/feed_video/get.dart';
import '../use_cases/photo/get.dart';

class UserNoteRepository extends RemoteDataRepository<UserNote> {
  UserNoteRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static UserNoteRepository? _i;

  static UserNoteRepository get i => _i ??= UserNoteRepository(
    source: RemoteUserNoteDataSource(),
    backup: LocalUserNoteDataSource(database: InAppDatabase.i),
  );

  @override
  Future<Response<UserNote>> get({
    DataFieldParams? params,
    Object? args,
    bool? lazy,
    bool? cached,
  }) {
    return super.get(cached: cached, params: params).then(_modify);
  }

  @override
  Future<Response<UserNote>> getById(
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
  Future<Response<UserNote>> getByIds(
    List<String> ids, {
    DataFieldParams? params,
    Object? args,
    bool? lazy,
    bool? cached,
  }) {
    return super.getByIds(ids, cached: cached, params: params).then(_modify);
  }

  @override
  Future<Response<UserNote>> getByQuery({
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

  Future<Response<UserNote>> _modify(
    Response<UserNote> value, [
    bool singleMode = false,
  ]) async {
    if (value.isSuccessful) {
      if (singleMode) {
        return value.copy(data: await _value(value.data));
      } else {
        List<UserNote> list = [];
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

  Future<UserNote?> _value(UserNote? i) async {
    if (i != null) {
      final photos = await GetPhotosUseCase.i(i.path.use).then((value) {
        return value.result;
      });
      final videos = await GetVideosUseCase.i(i.path.use).then((value) {
        return value.result;
      });
      return i.withUserNote(photos: photos, videos: videos);
    }
    return i;
  }
}
