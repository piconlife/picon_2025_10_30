// import '../../ldb/core/path.dart' show PathDetails;
// import '../../ldb/src/database.dart' show InAppWriteLimitation;
// import '../../ldb/src/delegate.dart' show InAppDatabaseDelegate;
//
// class InMemoryDelegate extends InAppDatabaseDelegate {
//   final Map<String, Map<String, Object?>> _stores = {};
//
//   @override
//   Future<bool> init(String dbName) async {
//     _stores.putIfAbsent(dbName, () => <String, Object?>{});
//     return true;
//   }
//
//   @override
//   Future<bool> drop(String dbName) async => _stores.remove(dbName) != null;
//
//   @override
//   Future<bool> delete(String dbName, String path) async {
//     final store = _stores[dbName];
//     if (store == null) return false;
//     return store.remove(path) != null;
//   }
//
//   @override
//   Future<Iterable<String>> paths(String dbName) async =>
//       List<String>.unmodifiable(_stores[dbName]?.keys ?? const <String>[]);
//
//   @override
//   Future<Object?> read(String dbName, String path) async =>
//       _stores[dbName]?[path];
//
//   @override
//   Future<bool> write(String dbName, String path, Object? data) async {
//     final store = _stores[dbName];
//     if (store == null) return false;
//     if (data == null) {
//       store.remove(path);
//     } else {
//       store[path] = data;
//     }
//     return true;
//   }
//
//   @override
//   Future<InAppWriteLimitation?> limitation(
//     String dbName,
//     PathDetails details,
//   ) async => null;
// }
