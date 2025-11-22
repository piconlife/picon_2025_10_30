import 'package:data_management/core.dart';

import '../../../app/helpers/user.dart';
import '../../repositories/bookmark.dart';

class BookmarkBaseUseCase {
  final BookmarkRepository repository;

  BookmarkBaseUseCase() : repository = BookmarkRepository.i;

  IterableParams get params => IterableParams([UserHelper.uid]);
}
