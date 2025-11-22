import 'package:data_management/data_management.dart';
import 'package:flutter_entity/entity.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/user_follower.dart';
import '../sources/local/user_follower.dart';
import '../sources/remote/user_follower.dart';
import '../use_cases/user/get.dart';

class UserFollowerRepository extends RemoteDataRepository<FollowerModel> {
  UserFollowerRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connected,
  });

  static UserFollowerRepository? _i;

  static UserFollowerRepository get i =>
      _i ??= UserFollowerRepository(
        source: RemoteUserFollowerDataSource(),
        backup: LocalUserFollowerDataSource(),
      );

  @override
  Future<Response<FollowerModel>> modifier(
    Response<FollowerModel> value,
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

  Future<Response<FollowerModel>> _modify(Response<FollowerModel> value) async {
    if (value.isValid) {
      if (value.result.length == 1) {
        return value.copyWith(data: await _value(value.data));
      } else {
        List<FollowerModel> list = [];
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

  Future<FollowerModel?> _value(FollowerModel? i) async {
    if (i == null) return null;
    return GetUserUseCase.i(i.id).then((value) {
      return i.copy(user: value.data);
    });
  }
}
