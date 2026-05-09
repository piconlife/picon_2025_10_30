part of 'base.dart';

mixin _WriteBatchMixin on _WriteEncryptMixin {
  DataDelegate get delegate;

  Future<void> _doWrite(
    List<DataBatchWriter> writers,
    DataEncryptor? encryptor, {
    bool parallelEncryption = true,
  }) async {
    if (writers.isEmpty) return;
    await _guardAsync(() async {
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
          batch.set(w.path, encrypted ?? w.data, merge: w.options.merge);
        } else if (w is DataUpdateWriter) {
          batch.update(w.path, encrypted ?? w.data);
        } else if (w is DataDeleteWriter) {
          batch.delete(w.path);
        }
      }
      if (batch.isEmpty) return;
      await batch.commit();
    }, operation: 'write');
  }
}
