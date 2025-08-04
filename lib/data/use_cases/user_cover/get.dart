import 'package:flutter_entity/entity.dart';

import '../../models/user_cover.dart';
import 'base.dart';

class GetUserCoversUseCase extends BaseUserCoverUseCase {
  GetUserCoversUseCase._();

  static GetUserCoversUseCase? _i;

  static GetUserCoversUseCase get i => _i ??= GetUserCoversUseCase._();

  Future<Response<UserCover>> call([String? uid]) {
    return repository.get(params: getParams(uid));
  }
}
