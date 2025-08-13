import 'package:flutter_entity/entity.dart';

import '../../models/user_post.dart';
import 'base.dart';

class GetUserPostsUseCase extends BaseUserPostUseCase {
  GetUserPostsUseCase._();

  static GetUserPostsUseCase? _i;

  static GetUserPostsUseCase get i => _i ??= GetUserPostsUseCase._();

  Future<Response<UserPost>> call({String? uid, bool singletonMode = true}) {
    return repository.get(singletonMode: singletonMode, params: getParams(uid));
  }
}
