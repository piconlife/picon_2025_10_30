import 'package:data_management/data_management.dart';
import 'package:flutter_andomie/core.dart' hide Selection;
import 'package:flutter_entity/entity.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/user_memory.dart';
import '../sources/local/user_memory.dart';
import '../sources/remote/user_memory.dart';
import '../use_cases/feed_video/get.dart';
import '../use_cases/content/get.dart';

class UserMemoryRepository extends RemoteDataRepository<UserMemory> {
  UserMemoryRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connected,
  });

  static UserMemoryRepository? _i;

  static UserMemoryRepository get i =>
      _i ??= UserMemoryRepository(
        source: RemoteUserMemoryDataSource(),
        backup: LocalUserMemoryDataSource(),
      );

  @override
  Future<Response<UserMemory>> modifier(
    Response<UserMemory> value,
    DataModifiers modifier,
  ) async {
    switch (modifier) {
      case DataModifiers.get:
      case DataModifiers.getById:
      case DataModifiers.getByIds:
      case DataModifiers.getByQuery:
      case DataModifiers.listen:
      case DataModifiers.listenById:
      case DataModifiers.listenByIds:
      case DataModifiers.listenByQuery:
        return _modify(value);
      case DataModifiers.checkById:
      case DataModifiers.clear:
      case DataModifiers.create:
      case DataModifiers.creates:
      case DataModifiers.deleteById:
      case DataModifiers.deleteByIds:
      case DataModifiers.search:
      case DataModifiers.updateById:
      case DataModifiers.updateByIds:
        return value;
      case DataModifiers.count:
        // TODO: Handle this case.
        throw UnimplementedError();
      case DataModifiers.listenCount:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Future<Response<UserMemory>> _modify(Response<UserMemory> value) async {
    if (value.isValid) {
      if (value.result.length == 1) {
        return value.copyWith(data: await _value(value.data));
      } else {
        List<UserMemory> list = [];
        for (var i in value.result) {
          final data = await _value(i);
          if (data != null) list.add(data);
        }
        return value.copyWith(result: list);
      }
    } else {
      return value;
    }
  }

  Future<UserMemory?> _value(UserMemory? i) async {
    if (i != null) {
      final photos = await GetsUseCase.i(i.path.use).then((value) {
        return value.result;
      });
      final videos = await GetVideosUseCase.i(i.path.use).then((value) {
        return value.result;
      });
      return i.withUserMemory(photos: photos, videos: videos);
    }
    return i;
  }
}
