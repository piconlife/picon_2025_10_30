import 'package:flutter_entity/entity.dart';

import '../../../packages/data_management.dart' show Checker, CheckerType;
import '../../models/user.dart';
import 'base.dart';

class FindUserByEmailUseCase extends BaseUserUseCase {
  FindUserByEmailUseCase._();

  static FindUserByEmailUseCase? _i;

  static FindUserByEmailUseCase get i => _i ??= FindUserByEmailUseCase._();

  Future<Response<UserModel>> call(String email) {
    return repository.search(
      Checker(field: UserKeys.i.email, value: email, type: CheckerType.equal),
    );
  }
}
