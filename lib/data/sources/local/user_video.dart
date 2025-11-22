import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_video.dart';

class LocalUserVideoDataSource extends InAppDataSource<VideoModel> {
  LocalUserVideoDataSource() : super(Paths.userVideos);

  @override
  VideoModel build(Object? source) => VideoModel.from(source);
}
