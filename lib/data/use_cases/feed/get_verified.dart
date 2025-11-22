import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../../app/helpers/user.dart';
import '../../constants/keys.dart';
import '../../models/feed.dart';
import 'base.dart';

class VerifiedFeedPaginationUseCase extends FeedBaseUseCase {
  VerifiedFeedPaginationUseCase._();

  static VerifiedFeedPaginationUseCase? _i;

  static VerifiedFeedPaginationUseCase get i =>
      _i ??= VerifiedFeedPaginationUseCase._();

  Future<Response<FeedModel>> call({
    int? initialSize,
    int? fetchingSize,
    Object? snapshot,
  }) async {
    if (UserHelper.approvals.isEmpty) {
      return Response(status: Status.notFound, error: "Followings not found!");
    }
    return repository.getByQuery(
      queries: [DataQuery(Keys.i.publisherId, whereIn: UserHelper.approvals)],
      selections: [DataSelection.startAfterDocument(snapshot)],
      sorts: [DataSorting(Keys.i.timeMills, descending: true)],
      options: DataPagingOptions(
        fetchingSize: fetchingSize,
        initialFetchSize: initialSize,
      ),
    );
  }
}
