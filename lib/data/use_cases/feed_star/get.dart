import 'package:flutter_entity/entity.dart';

import '../../models/feed_star.dart';
import 'base.dart';

class GetStarsUseCase extends BaseFeedStarUseCase {
  GetStarsUseCase._();

  static GetStarsUseCase? _i;

  static GetStarsUseCase get i => _i ??= GetStarsUseCase._();

  Future<Response<FeedStar>> call(String referencePath) {
    return repository.get(params: getParams(referencePath));
  }
}
