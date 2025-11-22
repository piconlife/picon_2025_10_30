import 'package:flutter_entity/entity.dart';

import '../../models/feed.dart';
import 'base.dart';

class FeedUpdateUseCase extends FeedBaseUseCase {
  FeedUpdateUseCase._();

  static FeedUpdateUseCase? _i;

  static FeedUpdateUseCase get i => _i ??= FeedUpdateUseCase._();

  Future<Response<FeedModel>> call(String id, Map<String, dynamic> data) {
    return repository.updateById(id, data, resolveRefs: true, updateRefs: true);
  }
}
