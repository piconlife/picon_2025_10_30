import 'package:flutter_entity/entity.dart';

import '../../models/feed.dart';
import 'base.dart';

class UpdateFeedUseCase extends BaseFeedUseCase {
  UpdateFeedUseCase._();

  static UpdateFeedUseCase? _i;

  static UpdateFeedUseCase get i => _i ??= UpdateFeedUseCase._();

  Future<Response<Feed>> call({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return repository.updateById(id, data);
  }
}
