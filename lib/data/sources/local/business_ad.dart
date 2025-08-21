import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/business_ad.dart';

class LocalBusinessAdDataSource extends LocalDataSource<BusinessAd> {
  LocalBusinessAdDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.businessAds);

  @override
  BusinessAd build(Object? source) => BusinessAd.from(source);
}
