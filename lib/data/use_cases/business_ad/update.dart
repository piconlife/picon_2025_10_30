import 'package:flutter_entity/entity.dart';

import '../../models/business_ad.dart';
import 'base.dart';

class UpdateBusinessAdUseCase extends BaseBusinessAdUseCase {
  UpdateBusinessAdUseCase._();

  static UpdateBusinessAdUseCase? _i;

  static UpdateBusinessAdUseCase get i => _i ??= UpdateBusinessAdUseCase._();

  Future<Response<BusinessAd>> call(String id, Map<String, dynamic> data) {
    return repository.updateById(id, data, params: params);
  }
}
