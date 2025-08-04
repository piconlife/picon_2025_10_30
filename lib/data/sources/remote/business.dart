import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/business.dart';

class RemoteBusinessDataSource extends FirestoreDataSource<Business> {
  RemoteBusinessDataSource({super.path = Paths.businesses});

  @override
  Business build(Object? source) => Business.from(source);
}
