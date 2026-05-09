part of 'base.dart';

mixin _WriteBatchMixin on _WriteEncryptMixin {
  DataDelegate get delegate;

  Future<void> _doWrite(
    List<DataBatchWriter> writers,
    DataEncryptor? encryptor, {
    bool parallelEncryption = true,
    int batchLimit = 500,
  }) async {
    if (writers.isEmpty) return;
    await _guardAsync(() async {
      final payloads = await _encryptAll(
        writers,
        encryptor,
        parallel: parallelEncryption,
      );
      for (var start = 0; start < writers.length; start += batchLimit) {
        final end = (start + batchLimit).clamp(0, writers.length);
        final batch = delegate.batch();
        for (var i = start; i < end; i++) {
          final w = writers[i];
          final encrypted = payloads[i];
          if (w is DataSetWriter) {
            batch.set(w.path, encrypted ?? w.data, merge: w.options.merge);
          } else if (w is DataUpdateWriter) {
            batch.update(w.path, encrypted ?? w.data);
          } else if (w is DataDeleteWriter) {
            batch.delete(w.path);
          }
        }
        if (batch.isEmpty) continue;
        await batch.commit();
      }
    }, operation: 'write');
  }
}
