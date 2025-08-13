import 'package:data_management/data_management.dart';
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
  Future<Response<UserPost>> modifier(
    Response<UserPost> value,
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
    }
  }

  Future<Response<UserPost>> _modify(Response<UserPost> value) async {
    if (value.isValid) {
      if (value.result.length == 1) {
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
