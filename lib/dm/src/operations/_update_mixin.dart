part of 'base.dart';

mixin _UpdateMixin on _ErrorHandlingMixin, _WriteTransformMixin {
  DataDelegate get delegate;

  Future<void> _doUpdate(
    String path,
    Map<String, dynamic> data, {
    required bool updateRefs,
  }) async {
    if (!updateRefs) {
      await _guardAsync(
        () => delegate.update(path, data),
        operation: 'update',
        path: path,
      );
      return;
    }
    await _guardAsync(
      () async {
        final batch = delegate.batch();
        final processed = _transformWrite(batch, data, true);
        batch.update(path, processed);
        await batch.commit();
      },
      operation: 'update.refs',
      path: path,
    );
  }
}
