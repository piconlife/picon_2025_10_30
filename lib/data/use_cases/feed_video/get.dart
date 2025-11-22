import 'package:flutter_entity/entity.dart';

import '../../models/feed_video.dart';
import 'base.dart';

class GetVideosUseCase extends BaseFeedVideoUseCase {
  GetVideosUseCase._();

  static GetVideosUseCase? _i;

  static GetVideosUseCase get i => _i ??= GetVideosUseCase._();

  Future<Response<VideoModel>> call(String referencePath) {
    return repository.get(params: getParams(referencePath));
  }
}
