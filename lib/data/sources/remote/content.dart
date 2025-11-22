import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/content.dart';

class RemoteContentDataSource extends FirestoreDataSource<ContentModel> {
  RemoteContentDataSource() : super(Paths.ref);

  @override
  ContentModel build(Object? source) => ContentModel.parse(source);
}
