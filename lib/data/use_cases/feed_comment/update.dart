import 'package:flutter_entity/entity.dart';

import '../../models/feed_comment.dart';
import 'base.dart';

class UpdateFeedCommentUseCase extends BaseFeedCommentUseCase {
  UpdateFeedCommentUseCase._();

  static UpdateFeedCommentUseCase? _i;

  static UpdateFeedCommentUseCase get i => _i ??= UpdateFeedCommentUseCase._();

  Future<Response<FeedComment>> call({
    required String referencePath,
    required String id,
    required Map<String, dynamic> data,
  }) {
    return repository.updateById(id, data, params: getParams(referencePath));
  }
}
