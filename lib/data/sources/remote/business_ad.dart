import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/business_ad.dart';

class RemoteBusinessAdDataSource extends FirestoreDataSource<BusinessAd> {
  RemoteBusinessAdDataSource({super.path = Paths.businessAds});

  @override
  BusinessAd build(Object? source) => BusinessAd.from(source);
}
