import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/business_sponsor.dart';

class RemoteBusinessSponsorDataSource
    extends FirestoreDataSource<BusinessSponsor> {
  RemoteBusinessSponsorDataSource({super.path = Paths.businessSponsors});

  @override
  BusinessSponsor build(Object? source) => BusinessSponsor.from(source);
}
