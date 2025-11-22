import 'package:flutter_entity/entity.dart';

import 'base.dart';

class CommentCountUseCase extends CommentBaseUseCase {
  CommentCountUseCase._();

  static CommentCountUseCase? _i;

  static CommentCountUseCase get i => _i ??= CommentCountUseCase._();

  Future<Response<int>> call(String path) {
    return repository.count(params: getParams(path));
  }
}
