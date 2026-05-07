part of 'operation.dart';

mixin _ErrorHandlingMixin {
  ErrorDelegate get errorDelegate;

  Future<T?> guardAsync<T>(
    Future<T> Function() task, {
    required String operation,
    String? path,
    T? fallback,
  }) async {
    try {
      return await task();
    } catch (e, s) {
      errorDelegate.onError(
        DataOperationError(
          operation: operation,
          path: path,
          cause: e,
          stack: s,
        ),
      );
      return fallback;
    }
  }
}
