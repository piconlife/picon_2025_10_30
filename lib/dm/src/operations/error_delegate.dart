import 'package:flutter/foundation.dart' show debugPrint;

import 'exception.dart' show DataOperationError;

abstract class ErrorDelegate {
  void onError(DataOperationError error);

  factory ErrorDelegate.silent() = _SilentErrorDelegate;

  factory ErrorDelegate.printing() = _PrintingErrorDelegate;
}

class _SilentErrorDelegate implements ErrorDelegate {
  const _SilentErrorDelegate();

  @override
  void onError(DataOperationError error) {}
}

class _PrintingErrorDelegate implements ErrorDelegate {
  const _PrintingErrorDelegate();

  @override
  void onError(DataOperationError error) {
    debugPrint('[DataOperation] $error\n${error.stack}');
  }
}
