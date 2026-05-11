import '../../app/imports/data_management.dart' show RemoteDataRepository;
import '../models/bookmark.dart' show BookmarkModel;
import '../sources/local/bookmark.dart' show LocalBookmarkDataSource;
import '../sources/remote/bookmark.dart' show RemoteBookmarkDataSource;

class BookmarkRepository extends RemoteDataRepository<BookmarkModel> {
  BookmarkRepository({required super.source, super.backup});

  static BookmarkRepository? _i;

  static BookmarkRepository get i =>
      _i ??= BookmarkRepository(
        source: RemoteBookmarkDataSource(),
        backup: LocalBookmarkDataSource(),
      );
}
