import 'package:flutter_entity/entity.dart';

import '../../models/user_post.dart';
import 'base.dart';

class GetUserPostUseCase extends BaseUserPostUseCase {
  GetUserPostUseCase._();

  static GetUserPostUseCase? _i;

  static GetUserPostUseCase get i => _i ??= GetUserPostUseCase._();

  Future<Response<UserPost>> call({
    required String id,
    String? uid,
    bool singletonMode = true,
  }) {
    return repository.getById(
      id,
      singletonMode: singletonMode,
      params: getParams(uid),
    );
  }
}
