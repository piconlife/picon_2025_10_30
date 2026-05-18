import 'dart:async';

class Isolate {
  static const int beforeNextEvent = 1;
  static const int immediate = 0;

  static Future<Isolate> spawn<T>(
    Function entryPoint,
    T message, {
    bool paused = false,
    bool errorsAreFatal = true,
    SendPort? onExit,
    SendPort? onError,
    String? debugName,
  }) async => Isolate._();

  Isolate._();

  void kill({int priority = beforeNextEvent}) {}
}

class ReceivePort extends Stream<dynamic> {
  final _controller = StreamController<dynamic>.broadcast();

  late final SendPort sendPort = SendPort._((msg) {
    if (!_controller.isClosed) _controller.add(msg);
  });

  @override
  StreamSubscription<dynamic> listen(
    void Function(dynamic)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) => _controller.stream.listen(
    onData,
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError,
  );

  void close() => _controller.close();
}

class SendPort {
  SendPort._(this._send);

  final void Function(dynamic) _send;

  void send(dynamic message) => _send(message);
}
