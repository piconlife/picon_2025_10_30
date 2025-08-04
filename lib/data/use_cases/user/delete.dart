import 'package:flutter_entity/entity.dart';

import '../../models/user.dart';
import 'base.dart';

class DeleteUserUseCase extends BaseUserUseCase {
  DeleteUserUseCase._();

  static DeleteUserUseCase? _i;

  static DeleteUserUseCase get i => _i ??= DeleteUserUseCase._();

  Future<Response<User>> call({required String uid}) {
    return repository.deleteById(uid);
  }
}
