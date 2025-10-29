import 'package:flutter_entity/entity.dart';

import '../../models/feed_star.dart';
import 'base.dart';

class DeleteFeedStarUseCase extends BaseFeedStarUseCase {
  DeleteFeedStarUseCase._();

  static DeleteFeedStarUseCase? _i;

  static DeleteFeedStarUseCase get i => _i ??= DeleteFeedStarUseCase._();

  Future<Response<FeedStar>> call(String parentPath, String id) {
    return repository.deleteById(id, params: getParams(parentPath));
  }
}
