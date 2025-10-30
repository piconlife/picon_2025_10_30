import 'package:flutter_entity/entity.dart';

import '../../models/feed.dart';
import 'base.dart';

class DeleteFeedUseCase extends BaseFeedUseCase {
  DeleteFeedUseCase._();

  static DeleteFeedUseCase? _i;

  static DeleteFeedUseCase get i => _i ??= DeleteFeedUseCase._();

  Future<Response<Feed>> call(String id) {
    return repository.deleteById(id, deleteRefs: true, counter: true);
  }
}
