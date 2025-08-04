import 'package:flutter_entity/entity.dart';

import '../../models/feed_comment.dart';
import 'base.dart';

class GetFeedCommentUseCase extends BaseFeedCommentUseCase {
  GetFeedCommentUseCase._();

  static GetFeedCommentUseCase? _i;

  static GetFeedCommentUseCase get i => _i ??= GetFeedCommentUseCase._();

  Future<Response<FeedComment>> call({
    required String id,
    required String referencePath,
  }) {
    return repository.getById(id, params: getParams(referencePath));
  }
}
