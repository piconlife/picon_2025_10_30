part of 'base.dart';

mixin _SourceWriteMixin<T extends Entity>
    on
        _SourceExecuteMixin<T>,
        _SourceEncryptionMixin<T>,
        _SourcePathMixin<T>,
        _SourceReadMixin<T> {
  @override
  DataDelegate get delegate;

  @override
  DataOperation get operation;

  @override
  DataLimitations get limitations;

  @override
  T build(dynamic source);

  Future<Response<T>> create(
    String id,
    Map<String, dynamic> data, {
    DataFieldParams? params,
    bool merge = true,
    bool createRefs = false,
  }) {
    if (id.isEmpty) return Future.value(Response(status: Status.invalidId));
    if (data.isEmpty) return Future.value(Response(status: Status.invalid));
    return execute(() async {
      final p = ref(params, DataModifiers.create, id);
      final encrypted = await encryptDoc(data);
      final payload = encrypted ?? data;
      await operation.create(p, payload, merge: merge, createRefs: createRefs);
      return Response(status: Status.ok, data: build(data));
    });
  }

  Future<Response<T>> creates(
    Iterable<DataWriter> writers, {
    DataFieldParams? params,
    bool merge = true,
    bool createRefs = false,
  }) {
    if (writers.isEmpty) return Future.value(Response(status: Status.invalid));
    return execute(() async {
      final results = await Future.wait(
        writers.map(
          (e) => create(
            e.id,
            e.data,
            params: params,
            createRefs: createRefs,
            merge: merge,
          ),
        ),
      );
      final ok = results.where((e) => e.isSuccessful);
      return Response(
        status: ok.length == writers.length ? Status.ok : Status.canceled,
        snapshot: results,
      );
    });
  }

  Future<Response<T>> updateById(
    String id,
    Map<String, dynamic> data, {
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool updateRefs = false,
  }) {
    if (id.isEmpty || data.isEmpty) {
      return Future.value(Response(status: Status.invalid));
    }
    return execute(() async {
      final p = ref(params, DataModifiers.updateById, id);
      final adjusted = data.map(
        (k, v) => MapEntry(k, delegate.updatingFieldValue(v)),
      );
      if (!isEncryptor) {
        await operation.update(p, adjusted, updateRefs: updateRefs);
        return Response(status: Status.ok);
      }
      final existing = await getById(
        id,
        params: params,
        countable: false,
        resolveRefs: resolveRefs ?? updateRefs,
        ignore: ignore,
      );
      final base = existing.data?.filtered ?? <String, dynamic>{};
      base.addAll(adjusted);
      final encrypted = await encryptDoc(base);
      if (encrypted == null) return Response(status: Status.nullable);
      await operation.update(p, encrypted, updateRefs: updateRefs);
      return Response(status: Status.ok);
    });
  }

  Future<Response<T>> updateByIds(
    Iterable<DataWriter> updates, {
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool updateRefs = false,
  }) {
    if (updates.isEmpty) return Future.value(Response(status: Status.invalid));
    return execute(() async {
      final results = await Future.wait(
        updates.map(
          (e) => updateById(
            e.id,
            e.data,
            params: params,
            resolveRefs: resolveRefs ?? updateRefs,
            ignore: ignore,
            updateRefs: updateRefs,
          ),
        ),
      );
      final ok = results.where((e) => e.isSuccessful);
      return Response(
        status: ok.length == updates.length ? Status.ok : Status.canceled,
        snapshot: results,
        backups: results.map((e) => e.data).whereType<T>().toList(),
      );
    });
  }

  Future<Response<T>> deleteById(
    String id, {
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool deleteRefs = false,
    bool counter = false,
  }) {
    if (id.isEmpty) return Future.value(Response(status: Status.invalidId));
    return execute(() async {
      final old = await getById(
        id,
        countable: false,
        params: params,
        resolveRefs: resolveRefs ?? deleteRefs,
        ignore: ignore,
      );
      if (!old.isValid) return old;
      final p = ref(params, DataModifiers.deleteById, id);
      await operation.delete(
        p,
        deleteRefs: deleteRefs,
        counter: counter,
        ignore: ignore,
        batchLimit: limitations.batchLimit,
        batchMaxLimit: limitations.maximumDeleteLimit,
      );
      return Response(status: Status.ok, backups: [old.data!]);
    });
  }

  Future<Response<T>> deleteByIds(
    Iterable<String> ids, {
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool deleteRefs = false,
    bool counter = false,
  }) {
    if (ids.isEmpty) return Future.value(Response(status: Status.invalid));
    return execute(() async {
      final results = await Future.wait(
        ids.map(
          (e) => deleteById(
            e,
            params: params,
            counter: counter,
            resolveRefs: resolveRefs ?? deleteRefs,
            ignore: ignore,
            deleteRefs: deleteRefs,
          ),
        ),
      );
      final ok = results.where((e) => e.isSuccessful);
      return Response(
        status: ok.length == ids.length ? Status.ok : Status.canceled,
        snapshot: results,
        backups: results.map((e) => e.data).whereType<T>().toList(),
      );
    });
  }

  Future<Response<T>> clear({
    DataFieldParams? params,
    bool? resolveRefs,
    bool deleteRefs = false,
    Ignore? ignore,
    bool counter = false,
  }) {
    return execute(() async {
      final p = ref(params, DataModifiers.clear);
      final value = await operation.get(
        p,
        countable: false,
        resolveRefs: resolveRefs ?? deleteRefs,
        ignore: ignore,
      );
      if (!value.exists) return Response(status: Status.notFound);
      final ids = value.docs.map((e) => e.id).whereType<String>().toList();
      if (ids.isEmpty) return Response(status: Status.notFound);
      final deleted = await deleteByIds(
        ids,
        params: params,
        counter: counter,
        deleteRefs: deleteRefs,
        ignore: ignore,
      );
      return deleted.copyWith(
        backups: value.docs.map((e) => build(e)).toList(),
        snapshot: value.snapshot,
        status: Status.ok,
      );
    });
  }

  Future<Response<void>> write(List<DataBatchWriter> writers) {
    if (writers.isEmpty) return Future.value(Response(status: Status.invalid));
    return execute(() async {
      await operation.write(writers, isEncryptor ? encryptor : null);
      return Response(status: Status.ok);
    });
  }
}
