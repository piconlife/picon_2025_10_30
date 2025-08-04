import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/feed_star.dart';
import 'base.dart';

class GetFeedStarsByPaginationUseCase extends BaseFeedStarUseCase {
  GetFeedStarsByPaginationUseCase._();

  static GetFeedStarsByPaginationUseCase? _i;

  static GetFeedStarsByPaginationUseCase get i {
    return _i ??= GetFeedStarsByPaginationUseCase._();
  }

  Future<Response<FeedStar>> call({
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
