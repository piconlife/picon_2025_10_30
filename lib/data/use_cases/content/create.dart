import 'package:flutter_entity/entity.dart';

import '../../models/content.dart';
import 'base.dart';

class CreatePhotoUseCase extends ContentBaseUseCase {
  CreatePhotoUseCase._();

  static CreatePhotoUseCase? _i;

  static CreatePhotoUseCase get i => _i ??= CreatePhotoUseCase._();

  Future<Response<Content>> call(Content data) async {
    return repository.create(data, params: getParams(data.contentPath ?? ""));
  }
}
