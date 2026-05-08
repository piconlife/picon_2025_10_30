part of 'base.dart';

mixin _RepoModifierMixin<T extends Entity> on _RepoExecutorMixin<T> {
  bool get backupMode;

  bool get lazyMode;

  bool get singletonMode;

  bool shouldUseBackup([bool? override]) =>
      optional != null && (override ?? backupMode);

  bool shouldUseLazy([bool? override]) => override ?? lazyMode;

  bool shouldUseSingleton([bool? override]) => override ?? singletonMode;

  Future<Response<T>> modifier(Response<T> value, DataModifiers modifier);

  Future<Response<T>> applyModifier(
    DataModifiers modifierId,
    Future<Response<T>> Function() callback,
  ) async {
    try {
      final value = await callback();
      return await modifier(value, modifierId);
    } catch (error, stack) {
      errorDelegate.onError(
        DataOperationError(
          operation: 'repository.modifier.$modifierId',
          cause: error,
          stack: stack,
        ),
      );
      return Response(status: Status.failure, error: error.toString());
    }
  }

  Stream<Response<T>> applyStreamModifier(
    DataModifiers modifierId,
    Stream<Response<T>> Function() callback,
  ) async* {
    Stream<Response<T>> source;
    try {
      source = callback();
    } catch (error, stack) {
      errorDelegate.onError(
        DataOperationError(
          operation: 'repository.streamModifier.construct.$modifierId',
          cause: error,
          stack: stack,
        ),
      );
      yield Response(status: Status.failure, error: error.toString());
      return;
    }
    await for (final value in source) {
      try {
        yield await modifier(value, modifierId);
      } catch (error, stack) {
        errorDelegate.onError(
          DataOperationError(
            operation: 'repository.streamModifier.$modifierId',
            cause: error,
            stack: stack,
          ),
        );
        yield Response(status: Status.failure, error: error.toString());
      }
    }
  }
}
