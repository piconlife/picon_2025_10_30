import 'package:flutter_entity/entity.dart';

import '../../models/user.dart';
import 'base.dart';

class ListenUserUseCase extends BaseUserUseCase {
  ListenUserUseCase._();

  static ListenUserUseCase? _i;

  static ListenUserUseCase get i => _i ??= ListenUserUseCase._();

  Stream<Response<UserModel>> call(String id) {
    return repository.listenById(id);
  }
}
