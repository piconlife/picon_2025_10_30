import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_report.dart';

class RemoteUserReportDataSource extends FirestoreDataSource<Report> {
  RemoteUserReportDataSource({super.path = Paths.userReports});

  @override
  Report build(Object? source) => Report.from(source);
}
