import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../models/user.dart';
import 'base.dart';

class CheckUsernameUseCase extends BaseUserUseCase {
  CheckUsernameUseCase._();

  static CheckUsernameUseCase? _i;

  static CheckUsernameUseCase get i => _i ??= CheckUsernameUseCase._();

  Future<Response<User>> call(String? name) {
    return repository.search(
      Checker(field: UserKeys.i.username, value: name, type: CheckerType.equal),
    );
  }
}
