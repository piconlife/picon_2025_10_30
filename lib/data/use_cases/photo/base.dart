import 'package:data_management/core.dart';

import '../../repositories/photo.dart';

class PhotoBaseUseCase {
  final PhotoRepository repository;

  PhotoBaseUseCase() : repository = PhotoRepository.i;

  IterableParams getParams(String path) {
    return IterableParams([path]);
  }
}
