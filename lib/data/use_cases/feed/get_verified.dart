import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../../app/helpers/user.dart';
import '../../constants/keys.dart';
import '../../models/feed.dart';
import 'base.dart';

class GetVerifiedFeedsByPaginationUseCase extends BaseFeedUseCase {
  GetVerifiedFeedsByPaginationUseCase._();

  static GetVerifiedFeedsByPaginationUseCase? _i;

  static GetVerifiedFeedsByPaginationUseCase get i =>
      _i ??= GetVerifiedFeedsByPaginationUseCase._();

  Future<Response<Feed>> call({
    int? initialSize,
    int? fetchingSize,
    Object? snapshot,
  }) async {
    if (UserHelper.approvals.isEmpty) {
      return Response(status: Status.notFound, error: "Followings not found!");
    }
    return repository.getByQuery(
      queries: [DataQuery(Keys.i.publisher, whereIn: UserHelper.approvals)],
      selections: [DataSelection.startAfterDocument(snapshot)],
      sorts: [DataSorting(Keys.i.timeMills, descending: true)],
      options: DataPagingOptions(
        fetchingSize: fetchingSize,
        initialFetchSize: initialSize,
      ),
    );
  }
}
