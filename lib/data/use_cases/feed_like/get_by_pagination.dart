import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/feed_like.dart';
import 'base.dart';

class GetFeedLikesByPaginationUseCase extends BaseFeedLikeUseCase {
  GetFeedLikesByPaginationUseCase._();

  static GetFeedLikesByPaginationUseCase? _i;

  static GetFeedLikesByPaginationUseCase get i {
    return _i ??= GetFeedLikesByPaginationUseCase._();
  }

  Future<Response<FeedLike>> call({
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
