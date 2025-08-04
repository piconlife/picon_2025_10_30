import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/photo.dart';

class RemoteFeedPhotoDataSource extends FirestoreDataSource<Photo> {
  RemoteFeedPhotoDataSource({super.path = Paths.refPhotos});

  @override
  Photo build(Object? source) => Photo.from(source);
}
