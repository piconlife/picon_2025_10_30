import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/content.dart';

class LocalContentDataSource extends LocalDataSource<Content> {
  LocalContentDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.ref);

  @override
  Content build(Object? source) => Content.parse(source);
}
