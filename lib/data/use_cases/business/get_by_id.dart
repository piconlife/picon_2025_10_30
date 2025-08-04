import 'package:flutter_entity/entity.dart';

import '../../../app/helpers/user.dart';
import '../../models/business.dart';
import 'base.dart';

class GetBusinessUseCase extends BaseBusinessUseCase {
  GetBusinessUseCase._();

  static GetBusinessUseCase? _i;

  static GetBusinessUseCase get i => _i ??= GetBusinessUseCase._();

  Future<Response<Business>> call([String? uid]) {
    return repository.getById(uid ?? UserHelper.uid);
  }
}
