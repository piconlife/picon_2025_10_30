import 'package:flutter_entity/entity.dart';

import '../../models/user.dart';
import 'base.dart';

class GetUserUseCase extends BaseUserUseCase {
  GetUserUseCase._();

  static GetUserUseCase? _i;

  static GetUserUseCase get i => _i ??= GetUserUseCase._();

  Future<Response<User>> call(String id, {bool cached = true}) {
    return repository.getById(id);
  }
}
