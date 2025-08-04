import 'package:flutter_entity/entity.dart';

import '../../models/feed.dart';
import 'base.dart';

class CreateFeedUseCase extends BaseFeedUseCase {
  CreateFeedUseCase._();

  static CreateFeedUseCase? _i;

  static CreateFeedUseCase get i => _i ??= CreateFeedUseCase._();

  Future<Response<Feed>> call(Feed data) async {
    return repository.create(data);
  }
}
