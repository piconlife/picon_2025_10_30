import 'package:flutter_entity/entity.dart';

import '../../models/star.dart';
import 'base.dart';

class GetStarUseCase extends BaseFeedStarUseCase {
  GetStarUseCase._();

  static GetStarUseCase? _i;

  static GetStarUseCase get i => _i ??= GetStarUseCase._();

  Future<Response<StarModel>> call(String parentPath, String id) {
    return repository.getById(id, params: getParams(parentPath));
  }
}
