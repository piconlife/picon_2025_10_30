import 'package:flutter_entity/entity.dart';

import '../../models/bookmark.dart';
import 'base.dart';

class BookmarkGetUseCase extends BookmarkBaseUseCase {
  BookmarkGetUseCase._();

  static BookmarkGetUseCase? _i;

  static BookmarkGetUseCase get i => _i ??= BookmarkGetUseCase._();

  Future<Response<BookmarkModel>> call(String id) {
    return repository.getById(id, params: params);
  }
}
