import 'package:flutter_entity/entity.dart';

import '../../models/like.dart';
import 'base.dart';

class CreateLikeUseCase extends BaseFeedLikeUseCase {
  CreateLikeUseCase._();

  static CreateLikeUseCase? _i;

  static CreateLikeUseCase get i => _i ??= CreateLikeUseCase._();

  Future<Response<LikeModel>> call(LikeModel data) async {
    if (data.parentPath == null) {
      return Response.failure("Parent path required!");
    }
    return repository.create(data, params: getParams(data.parentPath!));
  }
}
