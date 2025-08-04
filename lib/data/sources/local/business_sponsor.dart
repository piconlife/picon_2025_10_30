import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/business_sponsor.dart';

class LocalBusinessSponsorDataSource extends InAppDataSource<BusinessSponsor> {
  const LocalBusinessSponsorDataSource({
    super.path = Paths.businessSponsors,
    required super.database,
  });

  @override
  BusinessSponsor build(Object? source) => BusinessSponsor.from(source);
}
