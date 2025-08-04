import 'package:flutter_entity/entity.dart';

import '../../models/photo.dart';
import 'base.dart';

class UpdateFeedPhotoUseCase extends PhotoBaseUseCase {
  UpdateFeedPhotoUseCase._();

  static UpdateFeedPhotoUseCase? _i;

  static UpdateFeedPhotoUseCase get i => _i ??= UpdateFeedPhotoUseCase._();

  Future<Response<Photo>> call({
    required String referencePath,
    required String id,
    required Map<String, dynamic> data,
  }) {
    return repository.updateById(id, data, params: getParams(referencePath));
  }
}
