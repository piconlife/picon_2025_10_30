import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/photo.dart';

class LocalPhotoDataSource extends InAppDataSource<Photo> {
  const LocalPhotoDataSource({
    super.path = Paths.refPhotos,
    required super.database,
  });

  @override
  Photo build(Object? source) => Photo.from(source);
}
