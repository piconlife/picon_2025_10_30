import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/bookmark.dart';

class LocalBookmarkDataSource extends InAppDataSource<BookmarkModel> {
  LocalBookmarkDataSource() : super(Paths.userBookmarks);

  @override
  BookmarkModel build(Object? source) => BookmarkModel.parse(source);
}
