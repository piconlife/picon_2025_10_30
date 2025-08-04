import 'package:flutter_entity/entity.dart';

import '../../models/feed_video.dart';
import 'base.dart';

class DeleteFeedVideoUseCase extends BaseFeedVideoUseCase {
  DeleteFeedVideoUseCase._();

  static DeleteFeedVideoUseCase? _i;

  static DeleteFeedVideoUseCase get i => _i ??= DeleteFeedVideoUseCase._();

  Future<Response<FeedVideo>> call({required String id, required String path}) {
    return repository.deleteById(id, params: getParams(path));
  }
}
