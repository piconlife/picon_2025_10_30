import 'package:flutter_entity/entity.dart';

import '../../../app/imports/data_management.dart'
    show DataQuery, DataFetchOptions;
import '../../constants/keys.dart';
import '../../models/bookmark.dart';
import 'base.dart';

class BookmarkIsExistUseCase extends BookmarkBaseUseCase {
  BookmarkIsExistUseCase._();

  static BookmarkIsExistUseCase? _i;

  static BookmarkIsExistUseCase get i => _i ??= BookmarkIsExistUseCase._();

  Future<Response<BookmarkModel>> call(String path) async {
    final x = await repository.getByQuery(
      params: params,
      cacheMode: true,
      queries: [DataQuery(Keys.i.path, isEqualTo: path)],
      options: DataFetchOptions(initialFetchSize: 1, fetchingSize: 1),
    );
    return x;
  }
}
