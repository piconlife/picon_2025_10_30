import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/view.dart';

class LocalViewDataSource extends InAppDataSource<ViewModel> {
  LocalViewDataSource() : super(Paths.refViews);

  @override
  ViewModel build(Object? source) => ViewModel.parse(source);
}
