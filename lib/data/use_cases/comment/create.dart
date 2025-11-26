import 'package:flutter_entity/entity.dart';

import '../../models/feed_comment.dart';
import 'base.dart';

class CommentCreateUseCase extends CommentBaseUseCase {
  CommentCreateUseCase._();

  static CommentCreateUseCase? _i;

  static CommentCreateUseCase get i => _i ??= CommentCreateUseCase._();

  Future<Response<CommentModel>> call(CommentModel data) {
    return repository.create(data, params: getParams(data.parentPath ?? ""));
  }
}
