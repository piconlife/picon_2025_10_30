import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_video.dart';

class RemoteUserVideoDataSource extends FirestoreDataSource<VideoModel> {
  RemoteUserVideoDataSource() : super(Paths.userVideos);

  @override
  VideoModel build(Object? source) => VideoModel.from(source);
}
