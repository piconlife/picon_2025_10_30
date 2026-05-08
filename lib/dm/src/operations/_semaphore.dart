part of 'base.dart';

class DataOperationSemaphore {
  final int _max;
  int _active = 0;
  final Queue<Completer<void>> _waiters = Queue<Completer<void>>();

  DataOperationSemaphore(this._max) : assert(_max > 0);

  Future<T> run<T>(Future<T> Function() task) async {
    if (_active < _max) {
      _active++;
    } else {
      final c = Completer<void>();
      _waiters.add(c);
      await c.future;
    }
    try {
      return await task();
    } finally {
      if (_waiters.isEmpty) {
        _active--;
      } else {
        _waiters.removeFirst().complete();
      }
    }
  }
}
