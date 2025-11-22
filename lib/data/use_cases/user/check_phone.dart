import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../models/user.dart';
import 'base.dart';

class CheckPhoneUseCase extends BaseUserUseCase {
  CheckPhoneUseCase._();

  static CheckPhoneUseCase? _i;

  static CheckPhoneUseCase get i => _i ??= CheckPhoneUseCase._();

  Future<Response<UserModel>> call(String? phone) {
    return repository.search(
      Checker(field: UserKeys.i.phone, value: phone, type: CheckerType.equal),
    );
  }
}
