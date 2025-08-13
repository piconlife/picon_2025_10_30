import 'package:flutter_entity/entity.dart';

import '../../models/photo.dart';
import 'base.dart';

class GetFeedPhotoUseCase extends PhotoBaseUseCase {
  GetFeedPhotoUseCase._();

  static GetFeedPhotoUseCase? _i;

  static GetFeedPhotoUseCase get i => _i ??= GetFeedPhotoUseCase._();

  Future<Response<Photo>> call({
    required String id,
    required String referencePath,
    bool singletonMode = true,
  }) {
    return repository.getById(
      id,
      singletonMode: singletonMode,
      params: getParams(referencePath),
    );
  }
}
