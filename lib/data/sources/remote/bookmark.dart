import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/bookmark.dart';

class RemoteBookmarkDataSource extends FirestoreDataSource<BookmarkModel> {
  RemoteBookmarkDataSource() : super(Paths.userBookmarks);

  @override
  BookmarkModel build(Object? source) => BookmarkModel.parse(source);
}
