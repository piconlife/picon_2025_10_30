import 'package:flutter_entity/entity.dart';

import '../../models/feed_video.dart';
import 'base.dart';

class GetFeedVideoUseCase extends BaseFeedVideoUseCase {
  GetFeedVideoUseCase._();

  static GetFeedVideoUseCase? _i;

  static GetFeedVideoUseCase get i => _i ??= GetFeedVideoUseCase._();

  Future<Response<FeedVideo>> call({
    required String id,
    required String referencePath,
  }) {
    return repository.getById(id, params: getParams(referencePath));
  }
}
