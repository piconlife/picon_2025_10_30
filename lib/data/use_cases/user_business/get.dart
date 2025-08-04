import 'package:flutter_entity/entity.dart';

import '../../models/user_business.dart';
import 'base.dart';

class GetUserBusinessesUseCase extends BaseUserBusinessUseCase {
  GetUserBusinessesUseCase._();

  static GetUserBusinessesUseCase? _i;

  static GetUserBusinessesUseCase get i => _i ??= GetUserBusinessesUseCase._();

  Future<Response<UserBusiness>> call([String? uid]) {
    return repository.get(params: getParams(uid));
  }
}
