part of 'controller.dart';

typedef LazyFilterHandler =
    Future<FilterType> Function(
      Uint8List thumbnail,
      List<(FilterType, double)> rules,
    );

typedef EagerFilterHandler =
    Future<bool> Function(
      Uint8List thumbnail,
      List<(FilterType, double, bool)> rules,
    );

class _LazyTask {
  const _LazyTask(this.id, this.thumbnail, this.rules);

  final int id;
  final Uint8List thumbnail;
  final List<(FilterType, double)> rules;
}

class _LazyResult {
  const _LazyResult(this.id, this.type);

  final int id;
  final FilterType type;
}

class _EagerTask {
  const _EagerTask(this.id, this.thumbnail, this.rules);

  final int id;
  final Uint8List thumbnail;
  final List<(FilterType, double, bool)> rules;
}

class _EagerResult {
  const _EagerResult(this.id, this.include);

  final int id;
  final bool include;
}

@pragma('vm:entry-point')
Future<void> _isolateEntry(List<Object?> args) async {
  final replyTo = args[0] as SendPort;
  final lazyHandler = args[1] as LazyFilterHandler;
  final eagerHandler = args[2] as EagerFilterHandler;

  final inbox = ReceivePort();
  replyTo.send(inbox.sendPort);

  await for (final msg in inbox) {
    if (msg == null) {
      inbox.close();
      return;
    }

    if (msg is _LazyTask) {
      FilterType result;
      try {
        result = await lazyHandler(msg.thumbnail, msg.rules);
      } catch (_) {
        result = FilterType.none;
      }
      replyTo.send(_LazyResult(msg.id, result));
    } else if (msg is _EagerTask) {
      bool include;
      try {
        include = await eagerHandler(msg.thumbnail, msg.rules);
      } catch (_) {
        include = true;
      }
      replyTo.send(_EagerResult(msg.id, include));
    }
  }
}

class LazyFilterIsolate {
  LazyFilterIsolate({
    required LazyFilterHandler lazyHandler,
    required EagerFilterHandler eagerHandler,
  }) : _lazyHandler = lazyHandler,
       _eagerHandler = eagerHandler;

  final LazyFilterHandler _lazyHandler;
  final EagerFilterHandler _eagerHandler;

  Isolate? _isolate;
  ReceivePort? _port;
  SendPort? _inbox;

  final _lazyPending = <int, Completer<FilterType>>{};
  final _eagerPending = <int, Completer<bool>>{};
  final _readyCompleter = Completer<void>();
  int _nextId = 0;
  bool _disposed = false;

  Future<void> spawn() async {
    if (_disposed) return;

    if (kIsWeb) {
      if (!_readyCompleter.isCompleted) _readyCompleter.complete();
      return;
    }

    if (_isolate != null) return;

    _port =
        ReceivePort()..listen((msg) {
          if (msg is SendPort) {
            _inbox = msg;
            if (!_readyCompleter.isCompleted) _readyCompleter.complete();
          } else if (msg is _LazyResult) {
            _lazyPending.remove(msg.id)?.complete(msg.type);
          } else if (msg is _EagerResult) {
            _eagerPending.remove(msg.id)?.complete(msg.include);
          }
        });

    _isolate = await Isolate.spawn(_isolateEntry, [
      _port!.sendPort,
      _lazyHandler,
      _eagerHandler,
    ], debugName: 'filter_worker');

    await _readyCompleter.future;
  }

  Future<FilterType> process(
    Uint8List thumbnail,
    List<FilterRule> rules,
  ) async {
    if (_disposed) return FilterType.none;

    if (kIsWeb) {
      try {
        return await _lazyHandler(
          thumbnail,
          rules.map((r) => (r.type, r.accuracy)).toList(),
        );
      } catch (_) {
        return FilterType.none;
      }
    }

    await _readyCompleter.future;

    final id = _nextId++;
    final completer = Completer<FilterType>();
    _lazyPending[id] = completer;
    _inbox!.send(
      _LazyTask(id, thumbnail, rules.map((r) => (r.type, r.accuracy)).toList()),
    );
    return completer.future;
  }

  Future<bool> processEager(Uint8List thumbnail, List<FilterRule> rules) async {
    if (_disposed) return true;

    if (kIsWeb) {
      try {
        return await _eagerHandler(
          thumbnail,
          rules.map((r) => (r.type, r.accuracy, r.allow)).toList(),
        );
      } catch (_) {
        return true;
      }
    }

    await _readyCompleter.future;

    final id = _nextId++;
    final completer = Completer<bool>();
    _eagerPending[id] = completer;
    _inbox!.send(
      _EagerTask(
        id,
        thumbnail,
        rules.map((r) => (r.type, r.accuracy, r.allow)).toList(),
      ),
    );
    return completer.future;
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;

    if (!kIsWeb) {
      _inbox?.send(null);
      _isolate?.kill(priority: Isolate.beforeNextEvent);
      _port?.close();
    }

    for (final c in _lazyPending.values) {
      if (!c.isCompleted) c.complete(FilterType.none);
    }
    for (final c in _eagerPending.values) {
      if (!c.isCompleted) c.complete(true);
    }
    _lazyPending.clear();
    _eagerPending.clear();
  }
}
