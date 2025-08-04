import 'package:flutter_entity/entity.dart';

import '../../models/user_business.dart';
import 'base.dart';

class UpdateUserBusinessUseCase extends BaseUserBusinessUseCase {
  UpdateUserBusinessUseCase._();

  static UpdateUserBusinessUseCase? _i;

  static UpdateUserBusinessUseCase get i {
    return _i ??= UpdateUserBusinessUseCase._();
  }

  Future<Response<UserBusiness>> call(String id, Map<String, dynamic> data) {
    return repository.updateById(id, data, params: params);
  }
}
