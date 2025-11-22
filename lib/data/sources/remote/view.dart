import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/view.dart';

class RemoteViewDataSource extends RemoteDataSource<ViewModel> {
  RemoteViewDataSource()
    : super(
        delegate: FirestoreDataDelegate.i,
        path: Paths.refViews,
        limitations: DataLimitations(maximumDeleteLimit: 1000),
      );

  @override
  ViewModel build(Object? source) => ViewModel.parse(source);
}
