import 'package:data_management/core.dart' show Checker, CheckerType;
import 'package:flutter_entity/flutter_entity.dart';

import '../../models/user.dart';
import 'base.dart';

class CheckPhoneUseCase extends BaseUserUseCase {
  CheckPhoneUseCase._();

  static CheckPhoneUseCase? _i;

  static CheckPhoneUseCase get i => _i ??= CheckPhoneUseCase._();

  Future<Response<User>> call(String? phone) {
    return repository.search(
      Checker(field: UserKeys.i.phone, value: phone, type: CheckerType.equal),
    );
  }
}
