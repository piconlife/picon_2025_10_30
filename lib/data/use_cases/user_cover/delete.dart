import 'package:flutter_entity/entity.dart';

import '../../models/user_cover.dart';
import 'base.dart';

class DeleteUserCoverUseCase extends BaseUserCoverUseCase {
  DeleteUserCoverUseCase._();

  static DeleteUserCoverUseCase? _i;

  static DeleteUserCoverUseCase get i => _i ??= DeleteUserCoverUseCase._();

  Future<Response<UserCover>> call(String id) {
    return repository.deleteById(id, params: params);
  }
}
