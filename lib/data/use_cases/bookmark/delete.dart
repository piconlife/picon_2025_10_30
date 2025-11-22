import 'package:flutter_entity/entity.dart';

import '../../models/bookmark.dart';
import 'base.dart';

class BookmarkDeleteUseCase extends BookmarkBaseUseCase {
  BookmarkDeleteUseCase._();

  static BookmarkDeleteUseCase? _i;

  static BookmarkDeleteUseCase get i => _i ??= BookmarkDeleteUseCase._();

  Future<Response<BookmarkModel>> call(String id) {
    return repository.deleteById(id, params: params);
  }
}
