import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/feed.dart';
import 'base.dart';

class GetStarFeedsByPaginationUseCase extends BaseFeedUseCase {
  GetStarFeedsByPaginationUseCase._();

  static GetStarFeedsByPaginationUseCase? _i;

  static GetStarFeedsByPaginationUseCase get i =>
      _i ??= GetStarFeedsByPaginationUseCase._();

  Future<Response<Feed>> call({
    int? initialSize,
    int fetchingSize = 10,
    Object? snapshot,
  }) {
    return repository.get();
    return repository.getByQuery(
      queries: [DataQuery(Keys.i.publisherRating, isGreaterThanOrEqualTo: 3)],
      selections: [
        if (snapshot is List)
          DataSelection.startAfterDocument(snapshot.firstOrNull),
      ],
      sorts: [
        DataSorting(Keys.i.timeMills, descending: true),
        // DataSorting(Keys.i.publisherRating, descending: true),
      ],
      options: DataPagingOptions(
        initialFetchSize: initialSize,
        fetchingSize: fetchingSize,
      ),
    );
  }
}
