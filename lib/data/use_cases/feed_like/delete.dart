import 'package:flutter_entity/entity.dart';

import '../../models/feed_like.dart';
import 'base.dart';

class DeleteFeedLikeUseCase extends BaseFeedLikeUseCase {
  DeleteFeedLikeUseCase._();

  static DeleteFeedLikeUseCase? _i;

  static DeleteFeedLikeUseCase get i => _i ??= DeleteFeedLikeUseCase._();

  Future<Response<FeedLike>> call(String parentPath, String id) {
    return repository.deleteById(id, params: getParams(parentPath));
  }
}
