import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/view.dart';

class LocalViewDataSource extends LocalDataSource<ViewModel> {
  LocalViewDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.feedViews);

  @override
  ViewModel build(Object? source) => ViewModel.parse(source);
}
