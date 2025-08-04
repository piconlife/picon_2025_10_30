import 'package:flutter_entity/entity.dart';

import '../../models/user_business.dart';
import 'base.dart';

class GetUserBusinessUseCase extends BaseUserBusinessUseCase {
  GetUserBusinessUseCase._();

  static GetUserBusinessUseCase? _i;

  static GetUserBusinessUseCase get i => _i ??= GetUserBusinessUseCase._();

  Future<Response<UserBusiness>> call({required String id, String? uid}) {
    return repository.getById(id, params: getParams(uid));
  }
}
