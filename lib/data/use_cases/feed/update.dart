import 'package:flutter_entity/entity.dart';

import '../../models/feed.dart';
import 'base.dart';

class UpdateFeedUseCase extends BaseFeedUseCase {
  UpdateFeedUseCase._();

  static UpdateFeedUseCase? _i;

  static UpdateFeedUseCase get i => _i ??= UpdateFeedUseCase._();

  Future<Response<FeedModel>> call(String id, Map<String, dynamic> data) {
    return repository.updateById(id, data, resolveRefs: true, updateRefs: true);
  }
}
