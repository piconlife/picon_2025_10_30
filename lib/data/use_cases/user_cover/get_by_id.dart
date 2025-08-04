import 'package:flutter_entity/entity.dart';

import '../../models/user_cover.dart';
import 'base.dart';

class GetUserCoverUseCase extends BaseUserCoverUseCase {
  GetUserCoverUseCase._();

  static GetUserCoverUseCase? _i;

  static GetUserCoverUseCase get i => _i ??= GetUserCoverUseCase._();

  Future<Response<UserCover>> call({required String id, String? uid}) {
    return repository.getById(id, params: getParams(uid));
  }
}
