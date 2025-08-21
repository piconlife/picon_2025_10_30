import 'package:data_management/data_management.dart';
import 'package:flutter_entity/entity.dart';

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
    backup: LocalUserFollowingDataSource(),
  );

  @override
  Future<Response<UserFollowing>> modifier(
    Response<UserFollowing> value,
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

  Future<Response<UserFollowing>> _modify(Response<UserFollowing> value) async {
    if (value.isValid) {
      if (value.result.length == 1) {
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
      if (!value.isValid) return i;
      return i..content = value.data!;
    });
  }
}
