import 'package:flutter_entity/entity.dart';

import '../../models/star.dart';
import 'base.dart';

class DeleteStarUseCase extends BaseFeedStarUseCase {
  DeleteStarUseCase._();

  static DeleteStarUseCase? _i;

  static DeleteStarUseCase get i => _i ??= DeleteStarUseCase._();

  Future<Response<StarModel>> call(String parentPath, String id) {
    return repository.deleteById(id, params: getParams(parentPath));
  }
}
