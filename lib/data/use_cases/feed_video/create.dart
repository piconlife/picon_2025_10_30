import 'package:flutter_entity/entity.dart';

import '../../models/feed_video.dart';
import 'base.dart';

class CreateFeedVideoUseCase extends BaseFeedVideoUseCase {
  CreateFeedVideoUseCase._();

  static CreateFeedVideoUseCase? _i;

  static CreateFeedVideoUseCase get i => _i ??= CreateFeedVideoUseCase._();

  Future<Response<FeedVideo>> call(FeedVideo data) {
    return repository.create(data, params: getParams(data.parentPath ?? ""));
  }
}
