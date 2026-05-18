import 'package:flutter_entity/entity.dart';

import '../../../packages/data_management.dart'
    show DataSorting, DataSelection, DataFetchOptions;
import '../../constants/keys.dart';
import '../../models/bookmark.dart';
import 'base.dart';

class BookmarkPaginationUseCase extends BookmarkBaseUseCase {
  BookmarkPaginationUseCase._();

  static BookmarkPaginationUseCase? _i;

  static BookmarkPaginationUseCase get i {
    return _i ??= BookmarkPaginationUseCase._();
  }

  Future<Response<BookmarkModel>> call({
    int? initialSize,
    int? fetchingSize,
    Object? snapshot,
  }) {
    return repository.getByQuery(
      params: params,
      sorts: [DataSorting(Keys.i.timeMills, descending: true)],
      selections: [
        if (snapshot != null) DataSelection.startAfterDocument(snapshot),
      ],
      options: DataFetchOptions(
        initialFetchSize: initialSize,
        fetchingSize: fetchingSize,
      ),
    );
  }
}
