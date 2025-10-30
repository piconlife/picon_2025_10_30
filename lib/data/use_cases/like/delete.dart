import 'package:flutter_entity/entity.dart';

import '../../models/like.dart';
import 'base.dart';

class DeleteLikeUseCase extends BaseFeedLikeUseCase {
  DeleteLikeUseCase._();

  static DeleteLikeUseCase? _i;

  static DeleteLikeUseCase get i => _i ??= DeleteLikeUseCase._();

  Future<Response<LikeModel>> call(String parentPath, String id) {
    return repository.deleteById(id, params: getParams(parentPath));
  }
}
