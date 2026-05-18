import 'package:flutter_entity/entity.dart';

import '../../../packages/data_management.dart' show Checker, CheckerType;
import '../../models/user.dart';
import '../user/base.dart';

class CheckUserByPhoneUseCase extends BaseUserUseCase {
  CheckUserByPhoneUseCase._();

  static CheckUserByPhoneUseCase? _i;

  static CheckUserByPhoneUseCase get i => _i ??= CheckUserByPhoneUseCase._();

  Future<Response<UserModel>> call(String? phone) {
    return repository.search(
      Checker(field: UserKeys.i.phone, value: phone, type: CheckerType.equal),
    );
  }
}
