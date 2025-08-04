import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/business.dart';

class LocalBusinessDataSource extends InAppDataSource<Business> {
  const LocalBusinessDataSource({
    super.path = Paths.businesses,
    required super.database,
  });

  @override
  Business build(Object? source) => Business.from(source);
}
