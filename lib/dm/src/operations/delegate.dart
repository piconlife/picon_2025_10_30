import '../utils/checker.dart' show Checker;
import '../utils/fetch_options.dart' show DataFetchOptions;
import '../utils/query.dart' show DataQuery;
import '../utils/selection.dart' show DataSelection;
import '../utils/sorting.dart' show DataSorting;
import 'batch.dart' show DataWriteBatch;
import 'snapshots.dart'
    show DataGetsSnapshot, DataGetSnapshot, DataAggregateSnapshot;

abstract class DataDelegate {
  const DataDelegate();

  DataWriteBatch batch();

  Object resolveFieldPath(Object field, String documentId) => field;

  Object? resolveFieldValue(Object? value) => value;

  Future<int?> count(String path);

  Future<void> create(
    String path,
    Map<String, dynamic> data, [
    bool merge = true,
  ]);

  Future<void> delete(String path);

  Future<DataGetsSnapshot> get(String path);

  Future<DataGetSnapshot> getById(String path);

  Future<DataGetsSnapshot> getByQuery(
    String path, {
    Iterable<DataQuery> queries = const [],
    Iterable<DataSelection> selections = const [],
    Iterable<DataSorting> sorts = const [],
    DataFetchOptions options = const DataFetchOptions(),
  });

  Stream<DataGetsSnapshot> listen(String path);

  Stream<DataAggregateSnapshot> listenCount(String path);

  Stream<DataGetSnapshot> listenById(String path);

  Stream<DataGetsSnapshot> listenByQuery(
    String path, {
    Iterable<DataQuery> queries = const [],
    Iterable<DataSelection> selections = const [],
    Iterable<DataSorting> sorts = const [],
    DataFetchOptions options = const DataFetchOptions(),
  });

  Future<DataGetsSnapshot> search(String path, Checker checker);

  Future<void> update(String path, Map<String, dynamic> data);
}
