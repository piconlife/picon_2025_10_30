import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/unifier.dart';

class RemotePrefixUnifierDataSource extends RemoteDataSource<PrefixUnifier> {
  RemotePrefixUnifierDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.userEmails);

  @override
  PrefixUnifier build(Object? source) => PrefixUnifier.from(source);
}

class RemoteNameUnifierDataSource extends RemoteDataSource<NameUnifier> {
  RemoteNameUnifierDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.userNames);

  @override
  NameUnifier build(Object? source) => NameUnifier.from(source);
}

class RemotePhoneUnifierDataSource extends RemoteDataSource<PhoneUnifier> {
  RemotePhoneUnifierDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.userPhones);

  @override
  PhoneUnifier build(Object? source) => PhoneUnifier.from(source);
}
