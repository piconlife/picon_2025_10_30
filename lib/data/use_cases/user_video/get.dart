import 'package:flutter_entity/entity.dart';

import '../../models/user_video.dart';
import 'base.dart';

class GetUserVideosUseCase extends BaseUserVideoUseCase {
  GetUserVideosUseCase._();

  static GetUserVideosUseCase? _i;

  static GetUserVideosUseCase get i => _i ??= GetUserVideosUseCase._();

  Future<Response<UserVideo>> call([String? uid]) {
    return repository.get(params: getParams(uid));
  }
}
