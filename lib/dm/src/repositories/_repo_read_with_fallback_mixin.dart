part of 'base.dart';

mixin _RepoReadWithFallbackMixin<T extends Entity>
    on _RepoExecutorMixin<T>, _RepoModifierMixin<T> {
  Future<Response<T>> _readWithFallback({
    required DataModifiers modifierId,
    required Future<Response<T>> Function(DataSource<T> source) read,
    DataFieldParams? params,
    bool? createRefs,
    bool resolveRefs = false,
    bool merge = true,
    bool? lazyMode,
    bool? backupMode,
    bool? singletonMode,
    String? cacheKey,
    List<Object?> cacheKeyProps = const [],
  }) {
    return _applyModifier<T>(modifierId, () async {
      final feedback =
          cacheKey == null
              ? await _runOnPrimary(read)
              : await CacheManager.i.cache(
                cacheKey,
                enabled: _shouldUseSingleton(singletonMode),
                keyProps: cacheKeyProps,
                callback: () => _runOnPrimary(read),
              );
      if (feedback.isValid || !_shouldUseBackup(backupMode)) return feedback;

      final backup = await _runOnBackup(read);
      if (!backup.isValid) return backup;

      await _writeBackToPrimary(
        backup.result,
        params: params,
        createRefs: createRefs ?? resolveRefs,
        merge: merge,
        useLazy: _shouldUseLazy(lazyMode),
      );
      return backup;
    });
  }

  Future<void> _writeBackToPrimary(
    Iterable<T> result, {
    required DataFieldParams? params,
    required bool createRefs,
    required bool merge,
    required bool useLazy,
  }) async {
    if (result.isEmpty) return;
    final writers = result.map((e) => DataWriter(id: e.id, data: e.filtered));
    Future<Response<T>> task(DataSource<T> source) {
      return source.creates(
        writers,
        params: params,
        createRefs: createRefs,
        merge: merge,
      );
    }

    if (useLazy) {
      _runOnPrimaryLazy(task);
    } else {
      await _runOnPrimary(task);
    }
  }
}
