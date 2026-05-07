import '../../../app/imports/data_management.dart' show IterableParams;
import '../../repositories/feed_comment.dart';

class CommentBaseUseCase {
  final CommentRepository repository;

  CommentBaseUseCase() : repository = CommentRepository.i;

  IterableParams getParams(String path) {
    return IterableParams([path]);
  }
}
