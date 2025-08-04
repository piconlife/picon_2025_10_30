import 'package:flutter_entity/entity.dart';

import '../../models/user_business.dart';
import 'base.dart';

class DeleteUserBusinessUseCase extends BaseUserBusinessUseCase {
  DeleteUserBusinessUseCase._();

  static DeleteUserBusinessUseCase? _i;

  static DeleteUserBusinessUseCase get i {
    return _i ??= DeleteUserBusinessUseCase._();
  }

  Future<Response<UserBusiness>> call(String id) {
    return repository.deleteById(id, params: params);
  }
}
