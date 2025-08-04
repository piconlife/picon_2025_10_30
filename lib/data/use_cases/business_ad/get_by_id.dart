import 'package:flutter_entity/entity.dart';

import '../../models/business_ad.dart';
import 'base.dart';

class GetBusinessAdUseCase extends BaseBusinessAdUseCase {
  GetBusinessAdUseCase._();

  static GetBusinessAdUseCase? _i;

  static GetBusinessAdUseCase get i => _i ??= GetBusinessAdUseCase._();

  Future<Response<BusinessAd>> call({required String id, String? uid}) {
    return repository.getById(id, params: getParams(uid));
  }
}
