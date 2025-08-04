import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/photo.dart';

class RemotePhotoDataSource extends FirestoreDataSource<Photo> {
  RemotePhotoDataSource({super.path = Paths.refPhotos});

  @override
  Photo build(Object? source) => Photo.from(source);
}
