part of 'operation.dart';

mixin _WriteBatchMixin on _ErrorHandlingMixin {
  DataDelegate get delegate;

  Future<void> doWrite(
    List<DataBatchWriter> writers,
    DataEncryptor? encryptor,
  ) async {
    if (writers.isEmpty) return;
    await guardAsync(() async {
      final batch = delegate.batch();
      for (final w in writers) {
        if (w is DataSetWriter) {
          final raw = encryptor != null ? await encryptor.input(w.data) : null;
          batch.set(w.path, raw ?? w.data, w.options.merge);
        } else if (w is DataUpdateWriter) {
          final raw = encryptor != null ? await encryptor.input(w.data) : null;
          batch.update(w.path, raw ?? w.data);
        } else if (w is DataDeleteWriter) {
          batch.delete(w.path);
        }
      }
      await batch.commit();
    }, operation: 'write');
  }
}
