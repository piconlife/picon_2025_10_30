import 'package:flutter_entity/entity.dart';

import '../../models/business_ad.dart';
import 'base.dart';

class DeleteBusinessAdUseCase extends BaseBusinessAdUseCase {
  DeleteBusinessAdUseCase._();

  static DeleteBusinessAdUseCase? _i;

  static DeleteBusinessAdUseCase get i => _i ??= DeleteBusinessAdUseCase._();

  Future<Response<BusinessAd>> call(String id) {
    return repository.deleteById(id, params: params);
  }
}
