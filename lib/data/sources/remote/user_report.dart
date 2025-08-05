import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_report.dart';

class RemoteUserReportDataSource extends FirestoreDataSource<UserReport> {
  RemoteUserReportDataSource({super.path = Paths.userReports});

  @override
  UserReport build(Object? source) => UserReport.from(source);
}
