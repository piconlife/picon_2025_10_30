import '../../../app/helpers/user.dart';
import '../../../packages/data_management.dart' show IterableParams;
import '../../repositories/bookmark.dart';

class BookmarkBaseUseCase {
  final BookmarkRepository repository;

  BookmarkBaseUseCase() : repository = BookmarkRepository.i;

  IterableParams get params => IterableParams([UserHelper.uid]);
}
