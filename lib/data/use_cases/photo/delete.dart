import 'package:flutter_entity/entity.dart';

import '../../models/photo.dart';
import 'base.dart';

class DeletePhotoUseCase extends PhotoBaseUseCase {
  DeletePhotoUseCase._();

  static DeletePhotoUseCase? _i;

  static DeletePhotoUseCase get i => _i ??= DeletePhotoUseCase._();

  Future<Response<Photo>> call({required String id, required String path}) {
    return repository.deleteById(id, params: getParams(path));
  }
}
