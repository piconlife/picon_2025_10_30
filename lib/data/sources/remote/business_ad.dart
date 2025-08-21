import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/business_ad.dart';

class RemoteBusinessAdDataSource extends RemoteDataSource<BusinessAd> {
  RemoteBusinessAdDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.businessAds);

  @override
  BusinessAd build(Object? source) => BusinessAd.from(source);
}
