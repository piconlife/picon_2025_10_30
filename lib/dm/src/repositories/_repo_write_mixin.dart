part of 'base.dart';

mixin _RepoWriteMixin<T extends Entity>
    on
        _RepoExecutorMixin<T>,
        _RepoModifierMixin<T>,
        _RepoQueueMixin<T>,
        _RepoDualWriteMixin<T> {
  String _opId(String kind, [String? extra]) {
    final now = DateTime.now().microsecondsSinceEpoch;
    return '$queueId:$kind:${extra ?? ''}:$now';
  }

  List<Map<String, dynamic>> _writersToJson(Iterable<DataWriter> writers) {
    return writers.map((w) => {'id': w.id, 'data': w.data}).toList();
  }

  Future<Response<T>> create(
    T data, {
    DataFieldParams? params,
    bool merge = true,
    bool createRefs = false,
    bool? lazyMode,
    bool? backupMode,
    bool? queueMode,
  }) {
    return createById(
      data.id,
      data.filtered,
      params: params,
      merge: merge,
      createRefs: createRefs,
      lazyMode: lazyMode,
      backupMode: backupMode,
      queueMode: queueMode,
    );
  }

  Future<Response<T>> createById(
    String id,
    Map<String, dynamic> data, {
    DataFieldParams? params,
    bool merge = true,
    bool createRefs = false,
    bool? lazyMode,
    bool? backupMode,
    bool? queueMode,
  }) {
    if (id.isEmpty) {
      return Future.value(Response(status: Status.invalidId));
    }
    if (data.isEmpty) {
      return Future.value(Response(status: Status.invalid));
    }
    return _dualWrite(
      DataModifiers.create,
      backupMode: backupMode,
      lazyMode: lazyMode,
      queueMode: queueMode,
      write:
          (source) => source.create(
            id,
            data,
            params: params,
            createRefs: createRefs,
            merge: merge,
          ),
      opBuilder:
          () => DataQueuedOp(
            id: _opId('create', id),
            kind: DataQueuedOpKind.create,
            entityId: id,
            data: data,
            merge: merge,
            createRefs: createRefs,
          ),
    );
  }

  Future<Response<T>> creates(
    Iterable<T> data, {
    DataFieldParams? params,
    bool merge = true,
    bool createRefs = false,
    bool? lazyMode,
    bool? backupMode,
    bool? queueMode,
  }) {
    return createByWriters(
      data.map((e) => DataWriter(id: e.id, data: e.filtered)),
      params: params,
      merge: merge,
      createRefs: createRefs,
      lazyMode: lazyMode,
      backupMode: backupMode,
      queueMode: queueMode,
    );
  }

  Future<Response<T>> createByWriters(
    Iterable<DataWriter> writers, {
    DataFieldParams? params,
    bool merge = true,
    bool createRefs = false,
    bool? lazyMode,
    bool? backupMode,
    bool? queueMode,
  }) {
    if (writers.isEmpty) {
      return Future.value(Response(status: Status.invalid));
    }
    final list = writers.toList(growable: false);
    return _dualWrite(
      DataModifiers.creates,
      backupMode: backupMode,
      lazyMode: lazyMode,
      queueMode: queueMode,
      write:
          (source) => source.creates(
            list,
            params: params,
            merge: merge,
            createRefs: createRefs,
          ),
      opBuilder:
          () => DataQueuedOp(
            id: _opId('creates'),
            kind: DataQueuedOpKind.creates,
            writers: _writersToJson(list),
            merge: merge,
            createRefs: createRefs,
          ),
    );
  }

  Future<Response<T>> updateById(
    String id,
    Map<String, dynamic> data, {
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool updateRefs = false,
    bool? lazyMode,
    bool? backupMode,
    bool? queueMode,
  }) {
    if (id.isEmpty || data.isEmpty) {
      return Future.value(Response(status: Status.invalid));
    }
    return _dualWrite(
      DataModifiers.updateById,
      backupMode: backupMode,
      lazyMode: lazyMode,
      queueMode: queueMode,
      write:
          (source) => source.updateById(
            id,
            data,
            params: params,
            resolveRefs: resolveRefs,
            ignore: ignore,
            updateRefs: updateRefs,
          ),
      opBuilder:
          () => DataQueuedOp(
            id: _opId('updateById', id),
            kind: DataQueuedOpKind.updateById,
            entityId: id,
            data: data,
            updateRefs: updateRefs,
          ),
    );
  }

  Future<Response<T>> updateByWriters(
    Iterable<DataWriter> writers, {
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool updateRefs = false,
    bool? lazyMode,
    bool? backupMode,
    bool? queueMode,
  }) {
    if (writers.isEmpty) {
      return Future.value(Response(status: Status.invalid));
    }
    final list = writers.toList(growable: false);
    return _dualWrite(
      DataModifiers.updateByWriters,
      backupMode: backupMode,
      lazyMode: lazyMode,
      queueMode: queueMode,
      write:
          (source) => source.updateByWriters(
            list,
            params: params,
            resolveRefs: resolveRefs,
            ignore: ignore,
            updateRefs: updateRefs,
          ),
      opBuilder:
          () => DataQueuedOp(
            id: _opId('updateByWriters'),
            kind: DataQueuedOpKind.updateByWriters,
            writers: _writersToJson(list),
            updateRefs: updateRefs,
          ),
    );
  }

  Future<Response<T>> deleteById(
    String id, {
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool counter = false,
    bool deleteRefs = false,
    bool? lazyMode,
    bool? backupMode,
    bool? queueMode,
  }) {
    if (id.isEmpty) {
      return Future.value(Response(status: Status.invalidId));
    }
    return _dualWrite(
      DataModifiers.deleteById,
      backupMode: backupMode,
      lazyMode: lazyMode,
      queueMode: queueMode,
      write:
          (source) => source.deleteById(
            id,
            params: params,
            counter: counter,
            resolveRefs: resolveRefs,
            ignore: ignore,
            deleteRefs: deleteRefs,
          ),
      opBuilder:
          () => DataQueuedOp(
            id: _opId('deleteById', id),
            kind: DataQueuedOpKind.deleteById,
            entityId: id,
            deleteRefs: deleteRefs,
            counter: counter,
          ),
    );
  }

  Future<Response<T>> deleteByIds(
    Iterable<String> ids, {
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool counter = false,
    bool deleteRefs = false,
    bool? lazyMode,
    bool? backupMode,
    bool? queueMode,
  }) {
    if (ids.isEmpty) {
      return Future.value(Response(status: Status.invalid));
    }
    final list = ids.toList(growable: false);
    return _dualWrite(
      DataModifiers.deleteByIds,
      backupMode: backupMode,
      lazyMode: lazyMode,
      queueMode: queueMode,
      write:
          (source) => source.deleteByIds(
            list,
            params: params,
            counter: counter,
            resolveRefs: resolveRefs,
            ignore: ignore,
            deleteRefs: deleteRefs,
          ),
      opBuilder:
          () => DataQueuedOp(
            id: _opId('deleteByIds'),
            kind: DataQueuedOpKind.deleteByIds,
            ids: list,
            deleteRefs: deleteRefs,
            counter: counter,
          ),
    );
  }

  Future<Response<T>> clear({
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool deleteRefs = false,
    bool counter = false,
    bool? lazyMode,
    bool? backupMode,
    bool? queueMode,
  }) {
    return _dualWrite(
      DataModifiers.clear,
      backupMode: backupMode,
      lazyMode: lazyMode,
      queueMode: queueMode,
      write:
          (source) => source.clear(
            params: params,
            counter: counter,
            resolveRefs: resolveRefs,
            ignore: ignore,
            deleteRefs: deleteRefs,
          ),
      opBuilder:
          () => DataQueuedOp(
            id: _opId('clear'),
            kind: DataQueuedOpKind.clear,
            deleteRefs: deleteRefs,
            counter: counter,
          ),
    );
  }

  Future<Response<void>> write(List<DataBatchWriter> writers) async {
    if (writers.isEmpty) {
      return Response(status: Status.invalid);
    }
    final response = await _runOnPrimary<Object>((source) async {
      final r = await source.write(writers);
      return r.isSuccessful
          ? Response<Object>(status: Status.ok)
          : Response<Object>(status: r.status, error: r.error);
    });
    return Response(status: response.status, error: response.error);
  }
}
