import 'package:flutter_entity/entity.dart';

import '../../models/business_sponsor.dart';
import 'base.dart';

class GetBusinessSponsorsUseCase extends BaseBusinessSponsorUseCase {
  GetBusinessSponsorsUseCase._();

  static GetBusinessSponsorsUseCase? _i;

  static GetBusinessSponsorsUseCase get i {
    return _i ??= GetBusinessSponsorsUseCase._();
  }

  Future<Response<BusinessSponsor>> call([String? uid]) {
    return repository.get(params: getParams(uid));
  }
}
