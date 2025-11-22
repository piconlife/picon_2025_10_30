import 'package:data_management/core.dart';

import '../../repositories/feed_comment.dart';

class CommentBaseUseCase {
  final CommentRepository repository;

  CommentBaseUseCase() : repository = CommentRepository.i;

  IterableParams getParams(String path) {
    return IterableParams([path]);
  }
}
