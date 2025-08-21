import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/photo.dart';

class RemoteFeedPhotoDataSource extends RemoteDataSource<Photo> {
  RemoteFeedPhotoDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.refPhotos);

  @override
  Photo build(Object? source) => Photo.from(source);
}
