import 'package:flutter_entity/entity.dart';

import '../../models/photo.dart';
import 'base.dart';

class CreatePhotoUseCase extends PhotoBaseUseCase {
  CreatePhotoUseCase._();

  static CreatePhotoUseCase? _i;

  static CreatePhotoUseCase get i => _i ??= CreatePhotoUseCase._();

  Future<Response<Photo>> call(Photo data) {
    return repository.create(data, params: getParams(data.parentPath ?? ""));
  }
}
