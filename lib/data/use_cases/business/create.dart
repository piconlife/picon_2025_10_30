import 'package:flutter_entity/entity.dart';

import '../../models/business.dart';
import 'base.dart';

class CreateBusinessUseCase extends BaseBusinessUseCase {
  CreateBusinessUseCase._();

  static CreateBusinessUseCase? _i;

  static CreateBusinessUseCase get i => _i ??= CreateBusinessUseCase._();

  Future<Response<Business>> call(Business data) {
    return repository.create(data);
  }
}
