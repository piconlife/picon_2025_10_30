import 'package:flutter_entity/entity.dart';

import '../../models/user_business.dart';
import 'base.dart';

class CreateUserBusinessUseCase extends BaseUserBusinessUseCase {
  CreateUserBusinessUseCase._();

  static CreateUserBusinessUseCase? _i;

  static CreateUserBusinessUseCase get i {
    return _i ??= CreateUserBusinessUseCase._();
  }

  Future<Response<UserBusiness>> call(UserBusiness data) {
    return repository.create(data, params: params);
  }
}
