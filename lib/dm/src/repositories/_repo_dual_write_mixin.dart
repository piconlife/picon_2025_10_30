part of 'base.dart';

mixin _RepoDualWriteMixin<T extends Entity>
    on _RepoExecutorMixin<T>, _RepoModifierMixin<T> {
  Future<Response<T>> dualWrite(
    DataModifiers modifierId, {
    required Future<Response<T>> Function(DataSource<T> source) write,
    bool? backupMode,
    bool? lazyMode,
  }) {
    return applyModifier(modifierId, () async {
      if (shouldUseBackup(backupMode)) {
        if (shouldUseLazy(lazyMode)) {
          runOnBackupLazy(write);
        } else {
          await runOnBackup(write);
        }
      }
      return runOnPrimary(write);
    });
  }
}
