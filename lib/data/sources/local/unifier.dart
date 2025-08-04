import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/unifier.dart';

class LocalPrefixUnifierDataSource extends InAppDataSource<PrefixUnifier> {
  const LocalPrefixUnifierDataSource({
    super.path = Paths.userEmails,
    required super.database,
  });

  @override
  PrefixUnifier build(Object? source) => PrefixUnifier.from(source);
}

class LocalNameUnifierDataSource extends InAppDataSource<NameUnifier> {
  const LocalNameUnifierDataSource({
    super.path = Paths.userNames,
    required super.database,
  });

  @override
  NameUnifier build(Object? source) => NameUnifier.from(source);
}

class LocalPhoneUnifierDataSource extends InAppDataSource<PhoneUnifier> {
  const LocalPhoneUnifierDataSource({
    super.path = Paths.userPhones,
    required super.database,
  });

  @override
  PhoneUnifier build(Object? source) => PhoneUnifier.from(source);
}
