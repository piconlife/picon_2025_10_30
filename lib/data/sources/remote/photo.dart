import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/photo.dart';

class RemotePhotoDataSource extends RemoteDataSource<Photo> {
  RemotePhotoDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.userPhotos);

  @override
  Photo build(Object? source) => Photo.parse(source);
}
