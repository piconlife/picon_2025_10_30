import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/bookmark.dart';
import 'base.dart';

class BookmarkIsExistUseCase extends BookmarkBaseUseCase {
  BookmarkIsExistUseCase._();

  static BookmarkIsExistUseCase? _i;

  static BookmarkIsExistUseCase get i => _i ??= BookmarkIsExistUseCase._();

  Future<Response<BookmarkModel>> call(String id) {
    return repository.getByQuery(
      params: params,
      queries: [DataQuery(Keys.i.id, isEqualTo: id)],
      options: DataPagingOptions(initialFetchSize: 1, fetchingSize: 1),
    );
  }
}
