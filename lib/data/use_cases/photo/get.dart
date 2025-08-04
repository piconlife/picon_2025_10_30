import 'package:flutter_entity/entity.dart';

import '../../models/photo.dart';
import 'base.dart';

class GetPhotosUseCase extends PhotoBaseUseCase {
  GetPhotosUseCase._();

  static GetPhotosUseCase? _i;

  static GetPhotosUseCase get i => _i ??= GetPhotosUseCase._();

  Future<Response<Photo>> call(String referencePath, {bool cached = true}) {
    return repository.get(cached: cached, params: getParams(referencePath));
  }
}
