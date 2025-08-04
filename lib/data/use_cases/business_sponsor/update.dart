import 'package:flutter_entity/entity.dart';

import '../../models/business_sponsor.dart';
import 'base.dart';

class UpdateBusinessSponsorUseCase extends BaseBusinessSponsorUseCase {
  UpdateBusinessSponsorUseCase._();

  static UpdateBusinessSponsorUseCase? _i;

  static UpdateBusinessSponsorUseCase get i {
    return _i ??= UpdateBusinessSponsorUseCase._();
  }

  Future<Response<BusinessSponsor>> call(String id, Map<String, dynamic> data) {
    return repository.updateById(id, data, params: params);
  }
}
