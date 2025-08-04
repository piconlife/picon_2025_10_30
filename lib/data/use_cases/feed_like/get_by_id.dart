import 'package:flutter_entity/entity.dart';

import '../../models/feed_like.dart';
import 'base.dart';

class GetFeedLikeUseCase extends BaseFeedLikeUseCase {
  GetFeedLikeUseCase._();

  static GetFeedLikeUseCase? _i;

  static GetFeedLikeUseCase get i => _i ??= GetFeedLikeUseCase._();

  Future<Response<FeedLike>> call({
    required String id,
    required String referencePath,
  }) {
    return repository.getById(id, params: getParams(referencePath));
  }
}
