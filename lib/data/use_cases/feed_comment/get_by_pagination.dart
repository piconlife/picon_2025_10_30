import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/feed_comment.dart';
import 'base.dart';

class GetFeedCommentsByPaginationUseCase extends BaseFeedCommentUseCase {
  GetFeedCommentsByPaginationUseCase._();

  static GetFeedCommentsByPaginationUseCase? _i;

  static GetFeedCommentsByPaginationUseCase get i {
    return _i ??= GetFeedCommentsByPaginationUseCase._();
  }

  Future<Response<CommentModel>> call({
    required String referencePath,
    int? initialSize,
    int? fetchingSize,
    Object? snapshot,
  }) {
    return repository.getByQuery(
      params: getParams(referencePath),
      sorts: [DataSorting(Keys.i.timeMills, descending: true)],
      selections: [
        if (snapshot != null) DataSelection.startAfterDocument(snapshot),
      ],
      options: DataPagingOptions(
        initialFetchSize: initialSize,
        fetchingSize: fetchingSize,
      ),
    );
  }
}
