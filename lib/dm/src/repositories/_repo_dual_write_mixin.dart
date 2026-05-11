part of 'base.dart';

mixin _RepoDualWriteMixin<T extends Entity>
    on _RepoExecutorMixin<T>, _RepoModifierMixin<T>, _RepoQueueMixin<T> {
  Future<Response<T>> _dualWrite(
    DataModifiers modifierId, {
    required Future<Response<T>> Function(DataSource<T> source) write,
    required DataQueuedOp Function() opBuilder,
    bool? backupMode,
    bool? lazyMode,
  }) {
    return _applyModifier<T>(modifierId, () async {
      if (isLocalDB) {
        final primaryResponse = await _runOnPrimary(write);
        if (!primaryResponse.isSuccessful) return primaryResponse;
        if (_shouldUseBackup(backupMode)) {
          _scheduleBackup(opBuilder());
        }
        return primaryResponse;
      }
      final connected = await isConnected;
      if (!connected) {
        await _enqueuePrimary(opBuilder());
        if (_shouldUseBackup(backupMode)) {
          _runOnBackupLazy(write);
        }
        return Response(status: Status.ok);
      }
      final primaryResponse = await _runOnPrimary(write);
      if (!primaryResponse.isSuccessful) {
        if (primaryResponse.status == Status.networkError) {
          await _enqueuePrimary(opBuilder());
          if (_shouldUseBackup(backupMode)) {
            _runOnBackupLazy(write);
          }
          return Response(status: Status.ok);
        }
        return primaryResponse;
      }
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
