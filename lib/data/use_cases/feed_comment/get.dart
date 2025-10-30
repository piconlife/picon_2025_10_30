import 'package:flutter_entity/entity.dart';

import '../../models/feed_comment.dart';
import 'base.dart';

class GetCommentsUseCase extends BaseFeedCommentUseCase {
  GetCommentsUseCase._();

  static GetCommentsUseCase? _i;

  static GetCommentsUseCase get i => _i ??= GetCommentsUseCase._();

  Future<Response<CommentModel>> call(String referencePath) {
    return repository.get(params: getParams(referencePath));
  }
}
