import 'package:flutter_entity/entity.dart';

import '../../models/bookmark.dart';
import 'base.dart';

class BookmarkGetsUseCase extends BookmarkBaseUseCase {
  BookmarkGetsUseCase._();

  static BookmarkGetsUseCase? _i;

  static BookmarkGetsUseCase get i => _i ??= BookmarkGetsUseCase._();

  Future<Response<BookmarkModel>> call() {
    return repository.get(params: params);
  }
}
