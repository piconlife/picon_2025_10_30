import 'package:flutter_entity/entity.dart';

import '../../models/business_sponsor.dart';
import 'base.dart';

class CreateBusinessSponsorUseCase extends BaseBusinessSponsorUseCase {
  CreateBusinessSponsorUseCase._();

  static CreateBusinessSponsorUseCase? _i;

  static CreateBusinessSponsorUseCase get i {
    return _i ??= CreateBusinessSponsorUseCase._();
  }

  Future<Response<BusinessSponsor>> call(BusinessSponsor data) {
    return repository.create(data, params: params);
  }
}
