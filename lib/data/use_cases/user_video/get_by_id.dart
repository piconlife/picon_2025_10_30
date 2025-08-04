import 'package:flutter_entity/entity.dart';

import '../../models/user_video.dart';
import 'base.dart';

class GetUserVideoUseCase extends BaseUserVideoUseCase {
  GetUserVideoUseCase._();

  static GetUserVideoUseCase? _i;

  static GetUserVideoUseCase get i => _i ??= GetUserVideoUseCase._();

  Future<Response<UserVideo>> call({required String id, String? uid}) {
    return repository.getById(id, params: getParams(uid));
  }
}
