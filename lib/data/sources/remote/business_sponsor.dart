import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/business_sponsor.dart';

class RemoteBusinessSponsorDataSource
    extends RemoteDataSource<BusinessSponsor> {
  RemoteBusinessSponsorDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.businessSponsors);

  @override
  BusinessSponsor build(Object? source) => BusinessSponsor.from(source);
}
