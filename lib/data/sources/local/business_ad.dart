import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/business_ad.dart';

class LocalBusinessAdDataSource extends InAppDataSource<BusinessAd> {
  const LocalBusinessAdDataSource({
    super.path = Paths.businessAds,
    required super.database,
  });

  @override
  BusinessAd build(Object? source) => BusinessAd.from(source);
}
