import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../../app/helpers/user.dart';
import '../../constants/keys.dart';
import '../../models/comment.dart';
import 'base.dart';

class CommentGetsUseCase extends CommentBaseUseCase {
  CommentGetsUseCase._();

  static CommentGetsUseCase? _i;

  static CommentGetsUseCase get i => _i ??= CommentGetsUseCase._();

  Future<Response<CommentModel>> call(
    String path, {
    bool fetchForMe = true,
    int? limit,
  }) {
    return repository.getByQuery(
      params: getParams(path),
      queries: [
        if (fetchForMe)
          DataQuery(Keys.i.publisherId, isEqualTo: UserHelper.uid),
      ],
      options: DataPagingOptions(
        initialFetchSize: limit,
        fetchingSize: limit,
        fetchFromLast: limit != null,
      ),
    );
  }
}
