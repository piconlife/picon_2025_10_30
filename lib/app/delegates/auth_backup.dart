import 'dart:developer';

import 'package:auth_management/core.dart';
import 'package:data_management/core.dart';
import 'package:flutter_andomie/extensions.dart';

import '../../data/models/user.dart';
import '../../data/use_cases/user/create.dart';
import '../../data/use_cases/user/delete_user.dart';
import '../../data/use_cases/user/get.dart';
import '../../data/use_cases/user/update.dart';
import '../../features/startup/preferences/startup.dart';
import '../helpers/user.dart';

class InAppAuthBackupDelegate extends AuthBackupDelegate<User> {
  final _create = CreateUserUseCase.i;
  final _update = UpdateUserUseCase.i;
  final _delete = DeleteUserUseCase.i;
  final _fetch = GetUserUseCase.i;

  InAppAuthBackupDelegate()
    : super(
        key: UserHelper.key,
        reader: UserHelper.read,
        writer: UserHelper.write,
      );

  @override
  User build(Map source) => User.parse(source);

  @override
  Object? nonEncodableObjectParser(Object? current, Object? old) {
    if (current is DataFieldValue) {
      final value = current.value;
      switch (current.type) {
        case DataFieldValues.arrayUnion:
          if (value is! List) return old;
          if (old is Iterable) return [...old, ...value];
          return value;
        case DataFieldValues.arrayRemove:
          if (old is List && value is Iterable) {
            return old..removeWhere(value.contains);
          }
          return old;
        case DataFieldValues.delete:
          return null;
        case DataFieldValues.serverTimestamp:
          return DateTime.now().millisecondsSinceEpoch;
        case DataFieldValues.increment:
          if (value is! num) return old;
          if (old is num) return old + value;
          return value;
        case DataFieldValues.none:
          return null;
      }
    }
    return old;
  }

  @override
  Future<void> onCreateUser(User data) async {
    Map<String, dynamic> current = data.source;
    current.addAll(data.extra.use);
    current.addAll({
      UserKeys.i.name: Startup.i.fullname,
      UserKeys.i.username: Startup.i.shortname,
      UserKeys.i.birthday: Startup.i.birthday,
      UserKeys.i.gender: Startup.i.gender,
      UserKeys.i.email: Startup.i.email,
      UserKeys.i.country: Startup.i.isoCode,
      UserKeys.i.language: Startup.i.languageCode,
      UserKeys.i.phone: Startup.i.phone,
      UserKeys.i.password: Startup.i.password,
      UserKeys.i.latitude: Startup.i.latitude,
      UserKeys.i.longitude: Startup.i.longitude,
      UserKeys.i.provider: Startup.i.provider,
    });
    final user = User.parse(current);
    await _create(user: user);

    log("USER_CREATED");
  }

  @override
  Future<void> onDeleteUser(String id) => _delete(id);

  @override
  Future<User?> onFetchUser(String id) => _fetch(id).then((v) => v.data);

  @override
  Future<void> onUpdateUser(String id, Map<String, dynamic> data) {
    return _update(id, data);
  }
}
