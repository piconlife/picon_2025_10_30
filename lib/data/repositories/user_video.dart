import 'package:data_management/data_management.dart';
import 'package:flutter_andomie/core.dart' hide Selection;
import 'package:flutter_entity/entity.dart';

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
    backup: LocalUserVideoDataSource(),
  );

  @override
  Future<Response<UserVideo>> modifier(
    Response<UserVideo> value,
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

  Future<Response<UserVideo>> _modify(Response<UserVideo> value) async {
    if (value.isValid) {
      if (value.result.length == 1) {
        return value.copyWith(data: await _value(value.data));
      } else {
        List<UserVideo> list = [];
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

  Future<UserVideo?> _value(UserVideo? i) async {
    if (i != null) {
      return GetVideosUseCase.i(i.path.use).then((value) {
        return i.withUserVideo(videos: value.result);
      });
    }
    return i;
  }
}
