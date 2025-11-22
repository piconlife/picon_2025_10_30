import 'package:data_management/core.dart';

import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/view.dart';

class RemoteViewDataSource extends FirestoreDataSource<ViewModel> {
  RemoteViewDataSource()
    : super(
        Paths.refViews,
        limitations: DataLimitations(maximumDeleteLimit: 1000),
      );

  @override
  ViewModel build(Object? source) => ViewModel.parse(source);
}
