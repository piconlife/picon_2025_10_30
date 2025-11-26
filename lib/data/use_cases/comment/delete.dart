import 'package:flutter_entity/entity.dart';

import '../../models/feed_comment.dart';
import 'base.dart';

class CommentDeleteUseCase extends CommentBaseUseCase {
  CommentDeleteUseCase._();

  static CommentDeleteUseCase? _i;

  static CommentDeleteUseCase get i => _i ??= CommentDeleteUseCase._();

  Future<Response<CommentModel>> call({
    required String id,
    required String path,
  }) {
    return repository.deleteById(id, params: getParams(path));
  }
}
