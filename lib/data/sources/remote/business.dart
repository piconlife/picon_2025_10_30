import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/business.dart';

class RemoteBusinessDataSource extends RemoteDataSource<Business> {
  RemoteBusinessDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.businesses);

  @override
  Business build(Object? source) => Business.from(source);
}
