import 'package:flutter_entity/entity.dart';

import '../../models/business.dart';
import 'base.dart';

class GetBusinessesUseCase extends BaseBusinessUseCase {
  GetBusinessesUseCase._();

  static GetBusinessesUseCase? _i;

  static GetBusinessesUseCase get i => _i ??= GetBusinessesUseCase._();

  Future<Response<Business>> call() {
    return repository.get();
  }
}
