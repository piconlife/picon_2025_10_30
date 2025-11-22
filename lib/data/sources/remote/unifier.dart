import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/unifier.dart';

class RemotePrefixUnifierDataSource extends FirestoreDataSource<PrefixUnifier> {
  RemotePrefixUnifierDataSource() : super(Paths.userEmails);

  @override
  PrefixUnifier build(Object? source) => PrefixUnifier.from(source);
}

class RemoteNameUnifierDataSource extends FirestoreDataSource<NameUnifier> {
  RemoteNameUnifierDataSource() : super(Paths.userNames);

  @override
  NameUnifier build(Object? source) => NameUnifier.from(source);
}

class RemotePhoneUnifierDataSource extends FirestoreDataSource<PhoneUnifier> {
  RemotePhoneUnifierDataSource() : super(Paths.userPhones);

  @override
  PhoneUnifier build(Object? source) => PhoneUnifier.from(source);
}
