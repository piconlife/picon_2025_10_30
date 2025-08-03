import 'package:flutter_entity/flutter_entity.dart';

import '../../models/user.dart';
import 'base.dart';

class GetUsersUseCase extends BaseUserUseCase {
  GetUsersUseCase._();

  static GetUsersUseCase? _i;

  static GetUsersUseCase get i => _i ??= GetUsersUseCase._();

  Future<Response<User>> call() {
    return repository.get();
  }
}
