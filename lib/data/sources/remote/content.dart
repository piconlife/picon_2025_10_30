import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/content.dart';

class RemoteContentDataSource extends RemoteDataSource<Content> {
  RemoteContentDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.ref);

  @override
  Content build(Object? source) => Content.parse(source);
}
