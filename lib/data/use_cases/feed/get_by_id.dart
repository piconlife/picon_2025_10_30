import 'package:flutter_entity/entity.dart';

import '../../models/feed.dart';
import 'base.dart';

class GetFeedUseCase extends BaseFeedUseCase {
  GetFeedUseCase._();

  static GetFeedUseCase? _i;

  static GetFeedUseCase get i => _i ??= GetFeedUseCase._();

  Future<Response<Feed>> call(String id) {
    return repository.getById(id);
  }
}
