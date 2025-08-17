import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../../app/helpers/user.dart';
import '../../models/feed_comment.dart';
import 'base.dart';

class SearchByUserFeedCommentsUseCase extends BaseFeedCommentUseCase {
  SearchByUserFeedCommentsUseCase._();

  static SearchByUserFeedCommentsUseCase? _i;

  static SearchByUserFeedCommentsUseCase get i =>
      _i ??= SearchByUserFeedCommentsUseCase._();

  Future<Response<FeedComment>> call({
    required String id,
    required String referencePath,
    String? uid,
  }) {
    return repository.search(
      Checker(field: FeedCommentKeys.i.pid, value: uid ?? UserHelper.uid),
      params: getParams(referencePath),
    );
  }
}
