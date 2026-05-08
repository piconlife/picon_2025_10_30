part of 'base.dart';

mixin _CreateMixin on _ErrorHandlingMixin, _WriteTransformMixin {
  DataDelegate get delegate;

  Future<void> doCreate(
    String path,
    Map<String, dynamic> data, {
    required bool merge,
    required bool createRefs,
  }) async {
    if (!createRefs) {
      await guardAsync(
        () => delegate.create(path, data, merge),
        operation: 'create',
        path: path,
      );
      return;
    }
    await guardAsync(
      () async {
        final batch = delegate.batch();
        final transformed = transformWrite(batch, data, merge);
        batch.set(path, transformed, merge);
        await batch.commit();
      },
      operation: 'create.refs',
      path: path,
    );
  }
}
