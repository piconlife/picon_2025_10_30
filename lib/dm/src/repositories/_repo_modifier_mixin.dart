part of 'base.dart';

mixin _RepoModifierMixin<T extends Entity> on _RepoExecutorMixin<T> {
  bool get backupMode;

  bool get lazyMode;

  bool get singletonMode;

  bool _shouldUseBackup([bool? override]) =>
      optional != null && (override ?? backupMode);

  bool _shouldUseLazy([bool? override]) => override ?? lazyMode;

  bool _shouldUseSingleton([bool? override]) => override ?? singletonMode;

  Future<Response<T>> modifier(Response<T> value, DataModifiers modifier);

  Future<Response<S>> _applyModifier<S extends Object>(
    DataModifiers modifierId,
    Future<Response<S>> Function() callback,
  ) async {
    try {
      final value = await callback();
      if (value is Response<T>) {
        final modified = await modifier(value as Response<T>, modifierId);
        if (modified is Response<S>) return modified as Response<S>;
      }
      return value;
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

  Stream<Response<S>> _applyStreamModifier<S extends Object>(
    DataModifiers modifierId,
    Stream<Response<S>> Function() callback,
  ) async* {
    Stream<Response<S>> source;
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
        if (value is Response<T>) {
          final modified = await modifier(value as Response<T>, modifierId);
          if (modified is Response<S>) {
            yield modified as Response<S>;
            continue;
          }
        }
        yield value;
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
