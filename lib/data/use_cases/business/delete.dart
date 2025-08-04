import 'package:flutter_entity/entity.dart';

import '../../models/business.dart';
import 'base.dart';

class DeleteBusinessUseCase extends BaseBusinessUseCase {
  DeleteBusinessUseCase._();

  static DeleteBusinessUseCase? _i;

  static DeleteBusinessUseCase get i => _i ??= DeleteBusinessUseCase._();

  Future<Response<Business>> call(String uid) {
    return repository.deleteById(uid);
  }
}
