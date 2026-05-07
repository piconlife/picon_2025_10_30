import 'package:flutter_entity/entity.dart';

import '../../../app/imports/data_management.dart'
    show DataSorting, DataSelection, DataFetchOptions;
import '../../constants/keys.dart';
import '../../models/comment.dart';
import 'base.dart';

class CommentPaginationUseCase extends CommentBaseUseCase {
  CommentPaginationUseCase._();

  static CommentPaginationUseCase? _i;

  static CommentPaginationUseCase get i {
    return _i ??= CommentPaginationUseCase._();
  }

  Future<Response<CommentModel>> call({
    required String path,
    int? initialSize,
    int? fetchingSize,
    Object? snapshot,
  }) {
    return repository.getByQuery(
      params: getParams(path),
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
