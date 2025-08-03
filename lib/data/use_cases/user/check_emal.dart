import 'package:data_management/core.dart' show Checker, CheckerType;
import 'package:flutter_entity/flutter_entity.dart';

import '../../models/user.dart';
import 'base.dart';

class CheckEmailUseCase extends BaseUserUseCase {
  CheckEmailUseCase._();

  static CheckEmailUseCase? _i;

  static CheckEmailUseCase get i => _i ??= CheckEmailUseCase._();

  Future<Response<User>> call(String? email) {
    return repository.search(
      Checker(field: UserKeys.i.email, value: email, type: CheckerType.equal),
    );
  }
}
