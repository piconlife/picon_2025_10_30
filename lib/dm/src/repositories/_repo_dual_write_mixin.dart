part of 'base.dart';

mixin _RepoDualWriteMixin<T extends Entity>
    on _RepoExecutorMixin<T>, _RepoModifierMixin<T> {
  Future<Response<T>> _dualWrite(
    DataModifiers modifierId, {
    required Future<Response<T>> Function(DataSource<T> source) write,
    bool? backupMode,
    bool? lazyMode,
  }) {
    return _applyModifier<T>(modifierId, () async {
      final primaryResponse = await _runOnPrimary(write);
      if (!primaryResponse.isSuccessful) return primaryResponse;
      if (!_shouldUseBackup(backupMode)) return primaryResponse;
      if (_shouldUseLazy(lazyMode)) {
        _runOnBackupLazy(write);
      } else {
        await _runOnBackup(write);
      }
      return primaryResponse;
    });
  }
}
