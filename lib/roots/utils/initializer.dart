import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Initializer extends ChangeNotifier {
  Initializer._();

  String? _id;
  bool showLogs = false;

  final Map<String, AsyncCallback> _callbacks = {};
  final Map<String, bool> _loaded = {};
  final Map<String, String> _errors = {};

  static Initializer? _i;

  static Initializer get i => _i ??= Initializer._();

  static String get id => i._id ?? '';

  static bool isError(String id) => error(id).isNotEmpty;

  static bool isLoaded(String id) => i._loaded[id] ?? false;

  static bool isLoading(String id) => !isLoaded(id);

  static bool isNotify(String id) => i._id == id;

  static String error(String id) => i._errors[id] ?? '';

  static void setError(String id, String value, AsyncCallback callback) {
    i._errors[id] = value;
    i._callbacks[id] = callback;
    i._loaded[id] = false;
    i.notify(id);
    i._log("error($id): $value");
  }

  static void setLoaded(String id, bool value) {
    i._loaded[id] = value;
    i.notify(id);
    i._log("loaded($id): $value");
  }

  static Future<void> init(String id, AsyncCallback callback) async {
    try {
      setLoaded(id, true);
      callback()
          .whenComplete(() => setLoaded(id, true))
          .onError((e, s) => setError(id, e.toString(), callback))
          .catchError((e) => setError(id, e.toString(), callback));
    } catch (error) {
      setError(id, error.toString(), callback);
    }
  }

  Future<void> push(String id) async {
    final callback = _callbacks[id];
    if (callback == null) return;
    return init(id, callback);
  }

  Future<void> pushAll() async {
    for (final id in _callbacks.keys) {
      await push(id);
    }
  }

  void _log(String msg) {
    if (i.showLogs) log(msg, name: "$Initializer");
  }

  void notify(String id) {
    _id = id;
    notifyListeners();
  }

  @override
  void dispose() {
    _id = null;
    _errors.clear();
    _loaded.clear();
    super.dispose();
  }
}

class InitializerListener extends StatelessWidget {
  final List<String> ids;
  final Widget Function(BuildContext context, bool idsLoaded) builder;

  const InitializerListener({
    super.key,
    required this.ids,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Initializer.i,
      builder: (context, child) {
        return builder(context, ids.every(Initializer.isLoaded));
      },
    );
  }
}
