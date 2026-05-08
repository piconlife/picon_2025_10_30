part of 'base.dart';

mixin _DeleteMixin on _ErrorHandlingMixin {
  DataDelegate get delegate;

  Future<void> doDelete(
    String path, {
    required bool counter,
    required bool deleteRefs,
    required Ignore? ignore,
    required int batchLimit,
    int? batchMaxLimit,
  }) async {
    if (!deleteRefs) {
      await guardAsync(
        () => delegate.delete(path),
        operation: 'delete',
        path: path,
      );
      return;
    }
    await guardAsync(
      () => _cascadeDelete(
        path,
        counter: counter,
        ignore: ignore,
        batchLimit: batchLimit,
        batchMaxLimit: batchMaxLimit,
      ),
      operation: 'delete.refs',
      path: path,
    );
  }

  Future<void> _cascadeDelete(
    String root, {
    required bool counter,
    required Ignore? ignore,
    required int batchLimit,
    int? batchMaxLimit,
  }) async {
    final collector = _CascadeDeleteCollector(
      delegate: delegate,
      guard: guardAsync,
      counter: counter,
      ignore: ignore,
      maxLimit: batchMaxLimit,
    );

    await collector.collect(root);
    await _commitDeletions(collector.paths, root, batchLimit);
  }

  Future<void> _commitDeletions(
    List<String> paths,
    String root,
    int batchLimit,
  ) async {
    for (var i = 0; i < paths.length; i += batchLimit) {
      final end = (i + batchLimit).clamp(0, paths.length);
      final batch = delegate.batch();
      for (var j = i; j < end; j++) {
        batch.delete(paths[j]);
      }
      await guardAsync(
        () => batch.commit(),
        operation: 'delete.commit',
        path: root,
      );
    }
  }
}
