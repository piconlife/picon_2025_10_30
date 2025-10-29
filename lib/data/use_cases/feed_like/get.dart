import 'package:flutter_entity/entity.dart';

import '../../models/feed_like.dart';
import 'base.dart';

class GetLikesUseCase extends BaseFeedLikeUseCase {
  GetLikesUseCase._();

  static GetLikesUseCase? _i;

  static GetLikesUseCase get i => _i ??= GetLikesUseCase._();

  Future<Response<FeedLike>> call(String parentPath) {
    return repository.get(params: getParams(parentPath));
  }
}
