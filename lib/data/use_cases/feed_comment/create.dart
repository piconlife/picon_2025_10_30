import 'package:flutter_entity/entity.dart';

import '../../models/feed_comment.dart';
import 'base.dart';

class CreateFeedCommentUseCase extends BaseFeedCommentUseCase {
  CreateFeedCommentUseCase._();

  static CreateFeedCommentUseCase? _i;

  static CreateFeedCommentUseCase get i => _i ??= CreateFeedCommentUseCase._();

  Future<Response<FeedComment>> call(FeedComment data) {
    return repository.create(data, params: getParams(data.parentPath ?? ""));
  }
}
