import 'package:flutter_entity/entity.dart';

import '../../models/business_ad.dart';
import 'base.dart';

class CreateBusinessAdUseCase extends BaseBusinessAdUseCase {
  CreateBusinessAdUseCase._();

  static CreateBusinessAdUseCase? _i;

  static CreateBusinessAdUseCase get i => _i ??= CreateBusinessAdUseCase._();

  Future<Response<BusinessAd>> call(BusinessAd data) {
    return repository.create(data, params: params);
  }
}
