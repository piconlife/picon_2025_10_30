part of 'base.dart';

mixin _RepoWriteMixin<T extends Entity>
    on _RepoExecutorMixin<T>, _RepoModifierMixin<T>, _RepoDualWriteMixin<T> {
  Future<Response<T>> create(
    T data, {
    DataFieldParams? params,
    bool merge = true,
    bool createRefs = false,
    bool? lazyMode,
    bool? backupMode,
  }) {
    return createById(
      data.id,
      data.filtered,
      params: params,
      merge: merge,
      createRefs: createRefs,
      lazyMode: lazyMode,
      backupMode: backupMode,
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
  }) {
    return dualWrite(
      DataModifiers.create,
      backupMode: backupMode,
      lazyMode: lazyMode,
      write:
          (source) => source.create(
            id,
            data,
            params: params,
            createRefs: createRefs,
            merge: merge,
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
  }) {
    return createByWriters(
      data.map((e) => DataWriter(id: e.id, data: e.filtered)),
      params: params,
      merge: merge,
      createRefs: createRefs,
      lazyMode: lazyMode,
      backupMode: backupMode,
    );
  }

  Future<Response<T>> createByWriters(
    Iterable<DataWriter> writers, {
    DataFieldParams? params,
    bool merge = true,
    bool createRefs = false,
    bool? lazyMode,
    bool? backupMode,
  }) {
    return dualWrite(
      DataModifiers.creates,
      backupMode: backupMode,
      lazyMode: lazyMode,
      write:
          (source) => source.creates(
            writers,
            params: params,
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
  }) {
    return dualWrite(
      DataModifiers.updateById,
      backupMode: backupMode,
      lazyMode: lazyMode,
      write:
          (source) => source.updateById(
            id,
            data,
            params: params,
            resolveRefs: resolveRefs,
            ignore: ignore,
            updateRefs: updateRefs,
          ),
    );
  }

  Future<Response<T>> updateByIds(
    Iterable<DataWriter> updates, {
    DataFieldParams? params,
    bool? resolveRefs,
    Ignore? ignore,
    bool updateRefs = false,
    bool? lazyMode,
    bool? backupMode,
  }) {
    return dualWrite(
      DataModifiers.updateByIds,
      backupMode: backupMode,
      lazyMode: lazyMode,
      write:
          (source) => source.updateByIds(
            updates,
            params: params,
            resolveRefs: resolveRefs,
            ignore: ignore,
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
  }) {
    return dualWrite(
      DataModifiers.deleteById,
      backupMode: backupMode,
      lazyMode: lazyMode,
      write:
          (source) => source.deleteById(
            id,
            params: params,
            counter: counter,
            resolveRefs: resolveRefs,
            ignore: ignore,
            deleteRefs: deleteRefs,
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
  }) {
    return dualWrite(
      DataModifiers.deleteByIds,
      backupMode: backupMode,
      lazyMode: lazyMode,
      write:
          (source) => source.deleteByIds(
            ids,
            params: params,
            counter: counter,
            resolveRefs: resolveRefs,
            ignore: ignore,
            deleteRefs: deleteRefs,
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
  }) {
    return dualWrite(
      DataModifiers.clear,
      backupMode: backupMode,
      lazyMode: lazyMode,
      write:
          (source) => source.clear(
            params: params,
            counter: counter,
            resolveRefs: resolveRefs,
            ignore: ignore,
            deleteRefs: deleteRefs,
          ),
    );
  }

  Future<Response<void>> write(List<DataBatchWriter> writers) {
    return runOnPrimary((source) async {
      final response = await source.write(writers);
      return response.isSuccessful
          ? Response.ok()
          : Response.failure(response.error);
    });
  }
}
