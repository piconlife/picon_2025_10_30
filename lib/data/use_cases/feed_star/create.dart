import 'package:flutter_entity/entity.dart';

import '../../models/feed_star.dart';
import 'base.dart';

class CreateFeedStarUseCase extends BaseFeedStarUseCase {
  CreateFeedStarUseCase._();

  static CreateFeedStarUseCase? _i;

  static CreateFeedStarUseCase get i => _i ??= CreateFeedStarUseCase._();

  Future<Response<FeedStar>> call(FeedStar data) async {
    if (data.parentPath == null) {
      return Response.failure("Parent path required!");
    }
    return repository.create(data, params: getParams(data.parentPath!));
  }
}
