import 'package:flutter_entity/entity.dart';

import '../../models/business_ad.dart';
import 'base.dart';

class GetBusinessAdsUseCase extends BaseBusinessAdUseCase {
  GetBusinessAdsUseCase._();

  static GetBusinessAdsUseCase? _i;

  static GetBusinessAdsUseCase get i => _i ??= GetBusinessAdsUseCase._();

  Future<Response<BusinessAd>> call([String? uid]) {
    return repository.get(params: getParams(uid));
  }
}
