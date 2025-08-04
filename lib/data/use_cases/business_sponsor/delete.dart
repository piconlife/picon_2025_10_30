import 'package:flutter_entity/entity.dart';

import '../../models/business_sponsor.dart';
import 'base.dart';

class DeleteBusinessSponsorUseCase extends BaseBusinessSponsorUseCase {
  DeleteBusinessSponsorUseCase._();

  static DeleteBusinessSponsorUseCase? _i;

  static DeleteBusinessSponsorUseCase get i {
    return _i ??= DeleteBusinessSponsorUseCase._();
  }

  Future<Response<BusinessSponsor>> call(String id) {
    return repository.deleteById(id, params: params);
  }
}
