import 'package:flutter_entity/entity.dart';

import '../../models/feed_comment.dart';
import 'base.dart';

class DeleteFeedCommentUseCase extends BaseFeedCommentUseCase {
  DeleteFeedCommentUseCase._();

  static DeleteFeedCommentUseCase? _i;

  static DeleteFeedCommentUseCase get i => _i ??= DeleteFeedCommentUseCase._();

  Future<Response<CommentModel>> call({
    required String id,
    required String path,
  }) {
    return repository.deleteById(id, params: getParams(path));
  }
}
