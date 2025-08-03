import 'package:flutter_entity/flutter_entity.dart';

import '../../models/user.dart';
import 'base.dart';

class GetUserUseCase extends BaseUserUseCase {
  GetUserUseCase._();

  static GetUserUseCase? _i;

  static GetUserUseCase get i => _i ??= GetUserUseCase._();

  Future<Response<User>> call({required String uid}) {
    return repository.getById(uid);
  }
}
