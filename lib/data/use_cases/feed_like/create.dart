import 'package:flutter_entity/entity.dart';

import '../../models/feed_like.dart';
import 'base.dart';

class CreateFeedLikeUseCase extends BaseFeedLikeUseCase {
  CreateFeedLikeUseCase._();

  static CreateFeedLikeUseCase? _i;

  static CreateFeedLikeUseCase get i => _i ??= CreateFeedLikeUseCase._();

  Future<Response<FeedLike>> call(FeedLike data) {
    return repository.create(data, params: getParams(data.parentPath ?? ""));
  }
}
