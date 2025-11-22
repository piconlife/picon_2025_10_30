import 'package:flutter_entity/entity.dart';

import '../../models/feed.dart';
import 'base.dart';

class FeedCreateUseCase extends FeedBaseUseCase {
  FeedCreateUseCase._();

  static FeedCreateUseCase? _i;

  static FeedCreateUseCase get i => _i ??= FeedCreateUseCase._();

  Future<Response<FeedModel>> call(FeedModel data) async {
    return repository.create(data, createRefs: true);
  }
}
