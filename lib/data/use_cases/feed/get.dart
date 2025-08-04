import 'package:flutter_entity/entity.dart';

import '../../models/feed.dart';
import 'base.dart';

class GetFeedsUseCase extends BaseFeedUseCase {
  GetFeedsUseCase._();

  static GetFeedsUseCase? _i;

  static GetFeedsUseCase get i => _i ??= GetFeedsUseCase._();

  Future<Response<Feed>> call({String? uid}) {
    return repository.get();
  }
}
