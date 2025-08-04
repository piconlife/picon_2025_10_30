import 'package:flutter_entity/entity.dart';

import '../../models/business.dart';
import 'base.dart';

class UpdateBusinessUseCase extends BaseBusinessUseCase {
  UpdateBusinessUseCase._();

  static UpdateBusinessUseCase? _i;

  static UpdateBusinessUseCase get i => _i ??= UpdateBusinessUseCase._();

  Future<Response<Business>> call(String id, Map<String, dynamic> data) {
    return repository.updateById(id, data);
  }
}
