import 'package:flutter_entity/entity.dart';

import '../../models/star.dart';
import 'base.dart';

class GetStarsUseCase extends BaseFeedStarUseCase {
  GetStarsUseCase._();

  static GetStarsUseCase? _i;

  static GetStarsUseCase get i => _i ??= GetStarsUseCase._();

  Future<Response<StarModel>> call(String parentPath) {
    return repository.get(params: getParams(parentPath));
  }
}
