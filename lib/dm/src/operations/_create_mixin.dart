part of 'base.dart';

mixin _CreateMixin on _ErrorHandlingMixin, _WriteTransformMixin {
  DataDelegate get delegate;

  Future<void> _doCreate(
    String path,
    Map<String, dynamic> data, {
    required bool merge,
    required bool createRefs,
  }) async {
    if (!createRefs) {
      await _guardAsync(
        () => delegate.create(path, data, merge),
        operation: 'create',
        path: path,
      );
      return;
    }
    await _guardAsync(
      () async {
        final batch = delegate.batch();
        final transformed = _transformWrite(batch, data, merge);
        batch.set(path, transformed, merge: merge);
        await batch.commit();
      },
      operation: 'create.refs',
      path: path,
    );
  }
}
