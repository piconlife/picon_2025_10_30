import 'package:flutter_entity/entity.dart';

import '../../models/business_sponsor.dart';
import 'base.dart';

class GetBusinessSponsorUseCase extends BaseBusinessSponsorUseCase {
  GetBusinessSponsorUseCase._();

  static GetBusinessSponsorUseCase? _i;

  static GetBusinessSponsorUseCase get i {
    return _i ??= GetBusinessSponsorUseCase._();
  }

  Future<Response<BusinessSponsor>> call({required String id, String? uid}) {
    return repository.getById(id, params: getParams(uid));
  }
}
