import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/unifier.dart';

class RemotePrefixUnifierDataSource extends FirestoreDataSource<PrefixUnifier> {
  RemotePrefixUnifierDataSource({super.path = Paths.userEmails});

  @override
  PrefixUnifier build(Object? source) => PrefixUnifier.from(source);
}

class RemoteNameUnifierDataSource extends FirestoreDataSource<NameUnifier> {
  RemoteNameUnifierDataSource({super.path = Paths.userNames});

  @override
  NameUnifier build(Object? source) => NameUnifier.from(source);
}

class RemotePhoneUnifierDataSource extends FirestoreDataSource<PhoneUnifier> {
  RemotePhoneUnifierDataSource({super.path = Paths.userPhones});

  @override
  PhoneUnifier build(Object? source) => PhoneUnifier.from(source);
}
