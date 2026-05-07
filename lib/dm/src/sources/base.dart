import 'package:async/async.dart';
import 'package:flutter_entity/entity.dart';

import '../operations/operation.dart';
import '../utils/checker.dart';
import '../utils/configs.dart';
import '../utils/encryptor.dart';
import '../utils/extensions.dart';
import '../utils/limitations.dart';
import '../utils/modifiers.dart';
import '../utils/updating_info.dart';

abstract class DataSource<T extends Entity> {
  final String path;
  final DataDelegate delegate;
  final DataLimitations limitations;

  final DataEncryptor? encryptor;

  bool get isEncryptor => encryptor.isValid;

  DataOperation get operation => DataOperation(delegate);

  const DataSource({
    required this.path,
    required this.delegate,
    this.encryptor,
    this.limitations = const DataLimitations(),
  });

  Future<Response<S>> execute<S extends Object>(
    Future<Response<S>> Function() callback,
  ) async {
    try {
      return callback();
    } catch (error) {
      return Response<S>(status: Status.failure, error: error.toString());
    }
  }

  Stream<Response<S>> executeStream<S extends Object>(
    Stream<Response<S>> Function() callback,
  ) {
    try {
      return callback();
    } catch (error) {
      return Stream.value(
        Response<S>(status: Status.failure, error: error.toString()),
      );
    }
  }

  String ref(DataFieldParams? params, DataModifiers modifier, [String? id]) {
    final a = params.generate(path);
    if (id == null || id.isEmpty) return a;
    return "$a/$id";
  }

  Future<Response<T>> checkById(
    String id, {
    DataFieldParams? params,
    bool? countable,
    bool resolveRefs = false,
    Ignore? ignore,
  }) async {
    return execute(() {
      final path = ref(params, DataModifiers.checkById, id);
      return operation
          .getById(
            path,
            countable: countable ?? false,
            resolveRefs: resolveRefs,
            ignore: ignore,
          )
          .then((data) async {
            if (!data.exists) {
              return Response(status: Status.notFound);
            }
            final v = isEncryptor ? await encryptor.output(data.doc) : data.doc;
            return Response(
              status: Status.ok,
              data: build(v),
              snapshot: data.snapshot,
            );
          });
    });
  }

  Future<Response<T>> clear({
    DataFieldParams? params,
    bool? resolveRefs,
    bool deleteRefs = false,
    Ignore? ignore,
    bool counter = false,
  }) async {
    return execute(() {
      final path = ref(params, DataModifiers.clear);
      return operation
          .get(
            path,
            countable: false,
            resolveRefs: resolveRefs ?? deleteRefs,
            ignore: ignore,
          )
          .then((value) {
            if (!value.exists) return Response(status: Status.notFound);
            final ids =
                value.docs.map((e) => e.id).whereType<String>().toList();
            if (ids.isEmpty) return Response(status: Status.notFound);
            return execute(() {
              return deleteByIds(
                ids,
                params: params,
                counter: counter,
                deleteRefs: deleteRefs,
                ignore: ignore,
              ).then((deleted) {
                return deleted.copyWith(
                  backups: value.docs.map((e) => build(e)).toList(),
                  snapshot: value.snapshot,
                  status: Status.ok,
                );
              });
            });
          });
    });
  }

  Future<Response<int>> count({DataFieldParams? params}) async {
    return execute(() {
      final path = ref(params, DataModifiers.count);
      return operation.count(path).then((value) {
        return Response(status: Status.ok, data: value);
      });
    });
  }

  Future<Response<T>> create(
    String id,
    Map<String, dynamic> data, {
    DataFieldParams? params,
    bool merge = true,
    bool createRefs = false,
  }) async {
    if (id.isEmpty) return Response(status: Status.invalidId);
    if (data.isEmpty) return Response(status: Status.invalid);
    return execute(() {
      final path = ref(params, DataModifiers.create, id);
      if (isEncryptor) {
        return encryptor.input(data).then((raw) {
          if (raw.isEmpty) {
            return Response(status: Status.error, error: "Encryption error!");
          }
          return operation
              .create(path, raw, merge: merge, createRefs: createRefs)
              .then((value) {
                return Response(status: Status.ok, data: build(data));
              });
        });
      } else {
        return operation
            .create(path, data, merge: merge, createRefs: createRefs)
            .then((v) {
              return Response(status: Status.ok, data: build(data));
            });
      }
    });
  }

  Future<Response<T>> creates(
    Iterable<DataWriter> writers, {
    DataFieldParams? params,
    bool merge = true,
    bool createRefs = false,
  }) async {
    if (writers.isEmpty) return Response(status: Status.invalid);
    return execute(() {
      final callbacks = writers.map((e) {
        return create(
          e.id,
          e.data,
          params: params,
          createRefs: createRefs,
          merge: merge,
        );
      });
      return Future.wait(callbacks).then((value) {
        final x = value.where((e) => e.isSuccessful);
        return Response(
          status: x.length == writers.length ? Status.ok : Status.canceled,
          snapshot: value,
        );
      });
    });
  }

  Future<Response<T>> deleteById(
    String id, {
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool deleteRefs = false,
    bool counter = false,
  }) async {
    if (id.isEmpty) return Response(status: Status.invalidId);
    return execute(() {
      return getById(
        id,
        countable: false,
        params: params,
        resolveRefs: resolveRefs ?? deleteRefs,
        ignore: ignore,
      ).then((old) {
        if (!old.isValid) return old;
        final path = ref(params, DataModifiers.deleteById, id);
        return operation
            .delete(
              path,
              deleteRefs: deleteRefs,
              counter: counter,
              ignore: ignore,
              batchLimit: limitations.batchLimit,
              batchMaxLimit: limitations.maximumDeleteLimit,
            )
            .then((value) {
              return Response(status: Status.ok, backups: [old.data!]);
            });
      });
    });
  }

  Future<Response<T>> deleteByIds(
    Iterable<String> ids, {
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool deleteRefs = false,
    bool counter = false,
  }) async {
    if (ids.isEmpty) return Response(status: Status.invalid);
    return execute(() {
      final callbacks = ids.map((e) {
        return deleteById(
          e,
          params: params,
          counter: counter,
          resolveRefs: resolveRefs ?? deleteRefs,
          ignore: ignore,
          deleteRefs: deleteRefs,
        );
      });
      return Future.wait(callbacks).then((value) {
        final x = value.where((e) => e.isSuccessful);
        return Response(
          status: x.length == ids.length ? Status.ok : Status.canceled,
          snapshot: value,
          backups: value.map((e) => e.data).whereType<T>().toList(),
        );
      });
    });
  }

  Future<Response<T>> get({
    DataFieldParams? params,
    bool onlyUpdates = false,
    bool? countable,
    bool resolveRefs = false,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
  }) async {
    return execute(() {
      List<T> result = [];
      final path = ref(params, DataModifiers.get);
      return operation
          .get(
            path,
            countable: countable ?? true,
            resolveRefs: resolveRefs && !onlyUpdates,
            resolveDocChangesRefs:
                resolveDocChangesRefs || (onlyUpdates && resolveRefs),
            ignore: ignore,
          )
          .then((event) async {
            if (event.docs.isEmpty && event.docChanges.isEmpty) {
              return Response(
                status: Status.notFound,
                snapshot: event.snapshot,
              );
            }
            result.clear();
            for (var i in onlyUpdates ? event.docChanges : event.docs) {
              if (i.isEmpty) continue;
              final v = isEncryptor ? await encryptor.output(i) : i;
              result.add(build(v));
            }
            if (result.isEmpty) {
              return Response(
                status: Status.notFound,
                snapshot: event.snapshot,
              );
            }
            return Response(
              result: result,
              snapshot: event.snapshot,
              status: Status.ok,
            );
          });
    });
  }

  Future<Response<T>> getById(
    String id, {
    DataFieldParams? params,
    bool? countable,
    bool resolveRefs = false,
    Ignore? ignore,
  }) async {
    if (id.isEmpty) return Response(status: Status.invalidId);
    return execute(() {
      final path = ref(params, DataModifiers.getById, id);
      return operation
          .getById(
            path,
            countable: countable ?? true,
            resolveRefs: resolveRefs,
            ignore: ignore,
          )
          .then((event) async {
            if (!event.exists) {
              return Response(
                status: Status.notFound,
                snapshot: event.snapshot,
              );
            }
            final data = event.doc;
            final v = isEncryptor ? await encryptor.output(data) : data;
            return Response(
              status: Status.ok,
              data: build(v),
              snapshot: event.snapshot,
            );
          });
    });
  }

  Future<Response<T>> getByIds(
    Iterable<String> ids, {
    DataFieldParams? params,
    bool? countable,
    bool resolveRefs = false,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
  }) async {
    if (ids.isEmpty) return Response(status: Status.invalid);
    return execute(() {
      if (limitations.whereIn > 0 && ids.length > limitations.whereIn) {
        final callbacks = ids.map((e) {
          return getById(
            e,
            countable: countable,
            params: params,
            resolveRefs: resolveRefs,
            ignore: ignore,
          );
        });
        return Future.wait(callbacks).then((value) {
          final x = value.where((e) => e.isSuccessful);
          return Response(
            status: x.length == ids.length ? Status.ok : Status.canceled,
            result: value.map((e) => e.data).whereType<T>().toList(),
          );
        });
      } else {
        List<T> result = [];
        final path = ref(params, DataModifiers.getByIds);
        return operation
            .getByQuery(
              path,
              countable: countable ?? true,
              resolveRefs: resolveRefs,
              resolveDocChangesRefs: resolveDocChangesRefs,
              ignore: ignore,
              queries: [DataQuery(DataFieldPath.documentId, whereIn: ids)],
            )
            .then((event) async {
              if (event.docs.isEmpty) return Response(status: Status.notFound);
              result.clear();
              for (var i in event.docs) {
                if (i.isNotEmpty) {
                  var v = isEncryptor ? await encryptor.output(i) : i;
                  result.add(build(v));
                }
              }
              if (result.isEmpty) return Response(status: Status.notFound);
              return Response(
                status: Status.ok,
                result: result,
                snapshot: event,
              );
            });
      }
    });
  }

  Future<Response<T>> getByQuery({
    DataFieldParams? params,
    Iterable<DataQuery> queries = const [],
    Iterable<DataSelection> selections = const [],
    Iterable<DataSorting> sorts = const [],
    DataFetchOptions options = const DataFetchOptions(),
    bool? countable,
    bool onlyUpdates = false,
    bool resolveRefs = false,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
  }) async {
    return execute(() {
      List<T> result = [];
      final path = ref(params, DataModifiers.getByQuery);
      queries = queries.map((e) => e.adjust(delegate.queryFieldValue));
      selections = selections.map((e) => e.adjust(delegate.queryFieldValue));
      return operation
          .getByQuery(
            path,
            countable: countable ?? true,
            queries: queries,
            selections: selections,
            sorts: sorts,
            options: options,
            resolveRefs: resolveRefs && !onlyUpdates,
            resolveDocChangesRefs:
                resolveDocChangesRefs || (onlyUpdates && resolveRefs),
            ignore: ignore,
          )
          .then((event) async {
            if (event.docs.isEmpty && event.docChanges.isEmpty) {
              return Response(
                status: Status.notFound,
                snapshot: event.snapshot,
              );
            }
            result.clear();
            for (var i in onlyUpdates ? event.docChanges : event.docs) {
              if (i.isEmpty) continue;
              final v = isEncryptor ? await encryptor.output(i) : i;
              result.add(build(v));
            }
            if (result.isEmpty) {
              return Response(
                status: Status.notFound,
                snapshot: event.snapshot,
              );
            }
            return Response(
              result: result,
              snapshot: event.snapshot,
              status: Status.ok,
            );
          });
    });
  }

  Stream<Response<T>> listen({
    DataFieldParams? params,
    bool? countable,
    bool onlyUpdates = false,
    bool resolveRefs = false,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
  }) {
    return executeStream(() {
      List<T> result = [];
      final path = ref(params, DataModifiers.listen);
      return operation
          .listen(
            path,
            countable: countable ?? false,
            resolveRefs: resolveRefs && !onlyUpdates,
            resolveDocChangesRefs:
                resolveDocChangesRefs || (onlyUpdates && resolveRefs),
            ignore: ignore,
          )
          .asyncMap((event) async {
            if (event.docs.isEmpty && event.docChanges.isEmpty) {
              return Response(
                status: Status.notFound,
                snapshot: event.snapshot,
              );
            }
            result.clear();
            for (var i in onlyUpdates ? event.docChanges : event.docs) {
              if (i.isEmpty) continue;
              final v = isEncryptor ? await encryptor.output(i) : i;
              result.add(build(v));
            }
            if (result.isEmpty) return Response(status: Status.notFound);
            return Response(
              result: result,
              snapshot: event.snapshot,
              status: Status.ok,
            );
          });
    });
  }

  Stream<Response<int>> listenCount({
    DataFieldParams? params,
    Duration? interval,
  }) {
    return executeStream(() {
      final path = ref(params, DataModifiers.listenCount);
      return Stream.periodic(interval ?? Duration(seconds: 10)).asyncMap((_) {
        return operation.count(path).then((e) {
          return Response(data: e, status: Status.ok);
        });
      });
    });
  }

  Stream<Response<T>> listenById(
    String id, {
    DataFieldParams? params,
    bool? countable,
    bool resolveRefs = false,
    Ignore? ignore,
  }) {
    if (id.isEmpty) return Stream.value(Response(status: Status.invalidId));
    return executeStream(() {
      final path = ref(params, DataModifiers.listenById, id);
      return operation
          .listenById(
            path,
            countable: countable ?? false,
            resolveRefs: resolveRefs,
            ignore: ignore,
          )
          .asyncMap((event) async {
            if (!event.exists) return Response(status: Status.notFound);
            var data = event.doc;
            final v = isEncryptor ? await encryptor.output(data) : data;
            return Response(status: Status.ok, data: build(v), snapshot: event);
          });
    });
  }

  Stream<Response<T>> listenByIds(
    Iterable<String> ids, {
    DataFieldParams? params,
    bool? countable,
    bool resolveRefs = false,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
  }) {
    if (ids.isEmpty) return Stream.value(Response(status: Status.invalid));
    return executeStream(() {
      if (limitations.whereIn > 0 && ids.length > limitations.whereIn) {
        Map<String, T> map = {};
        return StreamGroup.merge(
          ids.map((e) {
            return listenById(
              e,
              countable: countable,
              params: params,
              resolveRefs: resolveRefs,
              ignore: ignore,
            );
          }),
        ).map((event) {
          final data = event.data;
          if (data != null) map[data.id] = data;
          if (map.isEmpty) return Response(status: Status.notFound);
          return Response(
            result: map.values.toList(),
            snapshot: event.snapshot,
            status: Status.ok,
          );
        });
      } else {
        List<T> result = [];
        final path = ref(params, DataModifiers.listenByIds);
        return operation
            .listenByQuery(
              path,
              countable: countable ?? false,
              resolveRefs: resolveRefs,
              resolveDocChangesRefs: resolveDocChangesRefs,
              ignore: ignore,
              queries: [DataQuery(DataFieldPath.documentId, whereIn: ids)],
            )
            .asyncMap((event) async {
              result.clear();
              if (event.docs.isNotEmpty) {
                for (final i in event.docs) {
                  if (i.isNotEmpty) {
                    final v = isEncryptor ? await encryptor.output(i) : i;
                    result.add(build(v));
                  }
                }
                if (result.isEmpty) {
                  return Response(
                    status: Status.notFound,
                    snapshot: event.snapshot,
                  );
                }
                return Response(
                  status: Status.ok,
                  result: result,
                  snapshot: event.snapshot,
                );
              }
              return Response(
                status: Status.notFound,
                snapshot: event.snapshot,
              );
            });
      }
    });
  }

  Stream<Response<T>> listenByQuery({
    DataFieldParams? params,
    Iterable<DataQuery> queries = const [],
    Iterable<DataSelection> selections = const [],
    Iterable<DataSorting> sorts = const [],
    DataFetchOptions options = const DataFetchOptions(),
    bool? countable,
    bool onlyUpdates = false,
    bool resolveRefs = false,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
  }) {
    return executeStream(() {
      List<T> result = [];
      final path = ref(params, DataModifiers.listenByQuery);
      queries = queries.map((e) => e.adjust(delegate.queryFieldValue));
      selections = selections.map((e) => e.adjust(delegate.queryFieldValue));
      return operation
          .listenByQuery(
            path,
            queries: queries,
            selections: selections,
            sorts: sorts,
            options: options,
            countable: countable ?? false,
            resolveRefs: resolveRefs && !onlyUpdates,
            resolveDocChangesRefs:
                resolveDocChangesRefs || (onlyUpdates && resolveRefs),
            ignore: ignore,
          )
          .asyncMap((event) async {
            if (event.docs.isEmpty && event.docChanges.isEmpty) {
              return Response(status: Status.notFound);
            }
            result.clear();
            for (var i in onlyUpdates ? event.docChanges : event.docs) {
              if (i.isEmpty) continue;
              final v = isEncryptor ? await encryptor.output(i) : i;
              result.add(build(v));
            }
            if (result.isEmpty) {
              return Response(
                status: Status.notFound,
                snapshot: event.snapshot,
              );
            }
            return Response(
              result: result,
              snapshot: event.snapshot,
              status: Status.ok,
            );
          });
    });
  }

  Future<Response<T>> search(
    Checker checker, {
    DataFieldParams? params,
    bool? countable,
    bool resolveRefs = false,
    bool resolveDocChangesRefs = false,
    Ignore? ignore,
  }) async {
    if (checker.field.isEmpty) return Response(status: Status.invalid);
    return execute(() {
      List<T> result = [];
      final path = ref(params, DataModifiers.search);
      return operation
          .search(
            path,
            countable: countable ?? false,
            checker,
            resolveRefs: resolveRefs,
            resolveDocChangesRefs: resolveDocChangesRefs,
            ignore: ignore,
          )
          .then((event) async {
            if (event.docs.isEmpty) return Response(status: Status.notFound);
            result.clear();
            for (final i in event.docs) {
              if (i.isNotEmpty) {
                final v = isEncryptor ? await encryptor.output(i) : i;
                result.add(build(v));
              }
            }
            if (result.isEmpty) return Response(status: Status.notFound);
            return Response(status: Status.ok, result: result, snapshot: event);
          });
    });
  }

  Future<Response<T>> updateById(
    String id,
    Map<String, dynamic> data, {
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool updateRefs = false,
  }) async {
    if (id.isEmpty || data.isEmpty) return Response(status: Status.invalid);
    return execute(() {
      final path = ref(params, DataModifiers.updateById, id);
      data = data.map((k, v) => MapEntry(k, delegate.updatingFieldValue(v)));
      if (!isEncryptor) {
        return operation
            .update(path, data, updateRefs: updateRefs)
            .then((value) => Response(status: Status.ok));
      }
      return getById(
        id,
        params: params,
        countable: false,
        resolveRefs: resolveRefs ?? updateRefs,
        ignore: ignore,
      ).then((value) {
        final x = value.data?.filtered ?? {};
        x.addAll(data);
        return encryptor.input(x).then((v) {
          if (v.isEmpty) return Response(status: Status.nullable);
          return operation
              .update(path, v, updateRefs: updateRefs)
              .then((value) => Response(status: Status.ok));
        });
      });
    });
  }

  Future<Response<T>> updateByIds(
    Iterable<DataWriter> updates, {
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool updateRefs = false,
  }) async {
    if (updates.isEmpty) return Response(status: Status.invalid);
    return execute(() {
      final callbacks = updates.map((e) {
        return updateById(
          e.id,
          e.data,
          params: params,
          resolveRefs: resolveRefs ?? updateRefs,
          ignore: ignore,
          updateRefs: updateRefs,
        );
      });
      return Future.wait(callbacks).then((value) {
        final x = value.where((e) => e.isSuccessful);
        return Response(
          status: x.length == updates.length ? Status.ok : Status.canceled,
          snapshot: value,
          backups: value.map((e) => e.data).whereType<T>().toList(),
        );
      });
    });
  }

  Future<Response<void>> write(List<DataBatchWriter> writers) async {
    if (writers.isEmpty) return Response(status: Status.invalid);
    return execute(() {
      return operation.write(writers, isEncryptor ? encryptor : null).then((v) {
        return Response(status: Status.ok);
      });
    });
  }

  T build(dynamic source);
}
