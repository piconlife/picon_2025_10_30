import 'package:flutter_entity/entity.dart';

import '../../models/feed.dart';
import 'base.dart';

class FeedDeleteUseCase extends FeedBaseUseCase {
  FeedDeleteUseCase._();

  static FeedDeleteUseCase? _i;

  static FeedDeleteUseCase get i => _i ??= FeedDeleteUseCase._();

  Future<Response<FeedModel>> call(String id) {
    return repository.deleteById(id, deleteRefs: true, counter: true);
  }
}
