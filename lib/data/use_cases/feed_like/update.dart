import 'package:flutter_entity/entity.dart';

import '../../models/feed_like.dart';
import 'base.dart';

class UpdateFeedLikeUseCase extends BaseFeedLikeUseCase {
  UpdateFeedLikeUseCase._();

  static UpdateFeedLikeUseCase? _i;

  static UpdateFeedLikeUseCase get i => _i ??= UpdateFeedLikeUseCase._();

  Future<Response<FeedLike>> call(
    String parentPath,
    String id,
    Map<String, dynamic> data,
  ) {
    return repository.updateById(id, data, params: getParams(parentPath));
  }
}
