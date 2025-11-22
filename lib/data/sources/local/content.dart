import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/content.dart';

class LocalContentDataSource extends InAppDataSource<ContentModel> {
  LocalContentDataSource() : super(Paths.ref);

  @override
  ContentModel build(Object? source) => ContentModel.parse(source);
}
