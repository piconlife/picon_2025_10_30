import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/business_sponsor.dart';

class LocalBusinessSponsorDataSource extends LocalDataSource<BusinessSponsor> {
  LocalBusinessSponsorDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.businessSponsors);

  @override
  BusinessSponsor build(Object? source) => BusinessSponsor.from(source);
}
