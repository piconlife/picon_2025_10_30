import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../data/models/feed.dart';
import '../../../../data/use_cases/feed/get_verified.dart';

class VerifiedFeedCubit extends DataCubit<FeedModel> {
  VerifiedFeedCubit(super.context);

  @override
  Future<Response<FeedModel>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    if (resultByMe) return Response(status: Status.undefined);
    return VerifiedFeedPaginationUseCase.i(
      initialSize: initialSize ?? 10,
      fetchingSize: fetchingSize ?? 5,
      snapshot: state.snapshot,
    );
  }
}
