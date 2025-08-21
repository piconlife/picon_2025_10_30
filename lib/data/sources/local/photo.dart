import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/photo.dart';

class LocalPhotoDataSource extends LocalDataSource<Photo> {
  LocalPhotoDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.refPhotos);

  @override
  Photo build(Object? source) => Photo.from(source);
}
