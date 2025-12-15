import 'package:flutter_entity/entity.dart';

import '../../models/comment.dart';
import 'base.dart';

class CommentUpdateUseCase extends CommentBaseUseCase {
  CommentUpdateUseCase._();

  static CommentUpdateUseCase? _i;

  static CommentUpdateUseCase get i => _i ??= CommentUpdateUseCase._();

  Future<Response<CommentModel>> call({
    required String id,
    required String path,
    required Map<String, dynamic> changes,
  }) {
    return repository.updateById(id, changes, params: getParams(path));
  }
}
