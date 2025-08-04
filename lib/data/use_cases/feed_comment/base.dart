import 'package:data_management/core.dart';

import '../../repositories/feed_comment.dart';

class BaseFeedCommentUseCase {
  final FeedCommentRepository repository;

  BaseFeedCommentUseCase() : repository = FeedCommentRepository.i;

  IterableParams getParams(String referencePath) {
    return IterableParams([referencePath]);
  }
}
