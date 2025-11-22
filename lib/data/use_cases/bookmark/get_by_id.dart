import 'package:flutter_entity/entity.dart';

import '../../models/like.dart';
import 'base.dart';

class GetLikeUseCase extends BaseFeedLikeUseCase {
  GetLikeUseCase._();

  static GetLikeUseCase? _i;

  static GetLikeUseCase get i => _i ??= GetLikeUseCase._();

  Future<Response<LikeModel>> call(String parentPath, String id) {
    return repository.getById(id, params: getParams(parentPath));
  }
}
