import 'package:data_management/data_management.dart';
import 'package:flutter_andomie/core.dart' hide Selection;
import 'package:flutter_entity/entity.dart';

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

  static UserNoteRepository get i =>
      _i ??= UserNoteRepository(
        source: RemoteUserNoteDataSource(),
        backup: LocalUserNoteDataSource(),
      );

  @override
  Future<Response<UserNote>> modifier(
    Response<UserNote> value,
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

  Future<Response<UserNote>> _modify(Response<UserNote> value) async {
    if (value.isValid) {
      if (value.result.length == 1) {
        return value.copyWith(data: await _value(value.data));
      } else {
        List<UserNote> list = [];
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
