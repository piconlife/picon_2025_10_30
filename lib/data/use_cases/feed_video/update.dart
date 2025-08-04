import 'package:flutter_entity/entity.dart';

import '../../models/feed_video.dart';
import 'base.dart';

class UpdateFeedVideoUseCase extends BaseFeedVideoUseCase {
  UpdateFeedVideoUseCase._();

  static UpdateFeedVideoUseCase? _i;

  static UpdateFeedVideoUseCase get i => _i ??= UpdateFeedVideoUseCase._();

  Future<Response<FeedVideo>> call({
    required String referencePath,
    required String id,
    required Map<String, dynamic> data,
  }) {
    return repository.updateById(id, data, params: getParams(referencePath));
  }
}
