import 'package:flutter_entity/entity.dart';

import '../../models/feed_star.dart';
import 'base.dart';

class DeleteFeedStarUseCase extends BaseFeedStarUseCase {
  DeleteFeedStarUseCase._();

  static DeleteFeedStarUseCase? _i;

  static DeleteFeedStarUseCase get i => _i ??= DeleteFeedStarUseCase._();

  Future<Response<FeedStar>> call({required String id, required String path}) {
    return repository.deleteById(id, params: getParams(path));
  }
}
