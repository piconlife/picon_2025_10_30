import 'package:flutter_entity/entity.dart';

import '../../models/feed_star.dart';
import 'base.dart';

class GetFeedStarUseCase extends BaseFeedStarUseCase {
  GetFeedStarUseCase._();

  static GetFeedStarUseCase? _i;

  static GetFeedStarUseCase get i => _i ??= GetFeedStarUseCase._();

  Future<Response<FeedStar>> call({
    required String id,
    required String referencePath,
  }) {
    return repository.getById(id, params: getParams(referencePath));
  }
}
