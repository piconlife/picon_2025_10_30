part of 'base.dart';

mixin _WriteBatchMixin on _ErrorHandlingMixin {
  DataDelegate get delegate;

  Future<void> doWrite(
    List<DataBatchWriter> writers,
    DataEncryptor? encryptor, {
    bool parallelEncryption = true,
  }) async {
    if (writers.isEmpty) return;
    await guardAsync(() async {
      final payloads = await _encryptAll(
        writers,
        encryptor,
        parallel: parallelEncryption,
      );
      final batch = delegate.batch();
      for (var i = 0; i < writers.length; i++) {
        final w = writers[i];
        final encrypted = payloads[i];
        if (w is DataSetWriter) {
          batch.set(w.path, encrypted ?? w.data, w.options.merge);
        } else if (w is DataUpdateWriter) {
          batch.update(w.path, encrypted ?? w.data);
        } else if (w is DataDeleteWriter) {
          batch.delete(w.path);
        }
      }
      await batch.commit();
    }, operation: 'write');
  }

  Future<List<Map<String, dynamic>?>> _encryptAll(
    List<DataBatchWriter> writers,
    DataEncryptor? encryptor, {
    required bool parallel,
  }) async {
    if (encryptor == null) {
      return List<Map<String, dynamic>?>.filled(writers.length, null);
    }

    Future<Map<String, dynamic>?> encryptOne(DataBatchWriter w) {
      if (w is DataSetWriter) return encryptor.input(w.data);
      if (w is DataUpdateWriter) return encryptor.input(w.data);
      return Future<Map<String, dynamic>?>.value(null);
    }

    if (parallel) {
      return Future.wait<Map<String, dynamic>?>(
        writers.map(encryptOne),
        eagerError: false,
      );
    }

    final out = <Map<String, dynamic>?>[];
    for (final w in writers) {
      out.add(await encryptOne(w));
    }
    return out;
  }
}
