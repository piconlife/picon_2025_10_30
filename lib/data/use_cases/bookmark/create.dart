import 'package:flutter_entity/entity.dart';

import '../../models/bookmark.dart';
import 'base.dart';

class BookmarkCreateUseCase extends BookmarkBaseUseCase {
  BookmarkCreateUseCase._();

  static BookmarkCreateUseCase? _i;

  static BookmarkCreateUseCase get i => _i ??= BookmarkCreateUseCase._();

  Future<Response<BookmarkModel>> call(BookmarkModel data) async {
    return repository.create(data, params: params);
  }
}
