import 'package:flutter_entity/entity.dart';

import '../../../app/imports/data_management.dart' show Checker, CheckerType;
import '../../models/user.dart';
import 'base.dart';

class FindUserByPhoneUseCase extends BaseUserUseCase {
  FindUserByPhoneUseCase._();

  static FindUserByPhoneUseCase? _i;

  static FindUserByPhoneUseCase get i => _i ??= FindUserByPhoneUseCase._();

  Future<Response<UserModel>> call(String phone) {
    return repository.search(
      Checker(field: UserKeys.i.phone, value: phone, type: CheckerType.equal),
    );
  }
}
