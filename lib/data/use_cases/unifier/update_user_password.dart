import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_entity/entity.dart';

import '../../models/user.dart';
import '../../parsers/user_parser.dart';
import '../user/base.dart';

class UpdateUserPasswordUseCase extends BaseUserUseCase {
  UpdateUserPasswordUseCase._();

  static UpdateUserPasswordUseCase? _i;

  static UpdateUserPasswordUseCase get i =>
      _i ??= UpdateUserPasswordUseCase._();

  Future<Response<UserModel>> call({
    required String uid,
    required String password,
  }) async {
    if (password.isEmpty) return Response(status: Status.invalid);
    final user = auth.FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Response(status: Status.notFound, error: "User not found!");
    }
    if (uid != user.uid) {
      return Response(status: Status.invalidId, error: "User not valid!");
    }
    final data = <String, dynamic>{
      UserKeys.i.password: UserParser.encryptPassword(password),
    };
    await user.updatePassword(password);
    return repository.updateById(uid, data);
  }
}
