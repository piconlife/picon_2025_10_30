import 'dart:isolate';

import 'package:flutter/cupertino.dart';

import '../contents/media.dart';
import 'storage.dart';

class IsolateTask {
  final String id;
  final String path;
  final MediaData data;

  const IsolateTask({required this.id, required this.path, required this.data});
}

class IsolateSnapshot {
  final String id;
  final IsolateStatus status;
  final dynamic value;

  const IsolateSnapshot({
    this.id = "",
    this.status = IsolateStatus.initial,
    this.value,
  });
}

enum IsolateStatus {
  initial,
  loading,
  processing,
  networkError,
  canceled,
  error,
  paused,
  done,
}

class UploadIsolation {
  static final Map<String, UploadIsolation> _proxies = {};

  static UploadIsolation of(String id) => _proxies[id] ??= UploadIsolation._();

  final Map<String, Isolate> _isolates = {};
  final ReceivePort _port = ReceivePort();

  final Map<String, ValueNotifier<IsolateSnapshot>> _snapshots = {};

  ValueNotifier<IsolateSnapshot> snapshotOf(String id) {
    return _snapshots[id] ??= ValueNotifier(IsolateSnapshot(id: id));
  }

  UploadIsolation._() {
    _port.listen(_listen);
  }

  void _listen(Object? value) {
    if (value is! IsolateSnapshot) return;
    snapshotOf(value.id).value = value;
  }

  static Future<void> _task(Map<String, dynamic> params) async {
    IsolateTask task = params["task"];
    SendPort port = params["port"];
    port.send(IsolateSnapshot(id: task.id));
    try {
      final data = task.data;
      StorageService.i.upload(
        task.path,
        UploadingFile(
          data: data.data,
          extension: data.extension,
          filename: data.filename,
        ),
        onCanceled:
            (event) => port.send(
              IsolateSnapshot(
                id: task.id,
                status: IsolateStatus.canceled,
                value: event.value,
              ),
            ),
        onDone:
            (event) => port.send(
              IsolateSnapshot(
                id: task.id,
                status: IsolateStatus.done,
                value: event.value,
              ),
            ),
        onError:
            (event) => port.send(
              IsolateSnapshot(
                id: task.id,
                status: IsolateStatus.error,
                value: event.value,
              ),
            ),
        onLoading:
            (event) => port.send(
              IsolateSnapshot(
                id: task.id,
                status: IsolateStatus.loading,
                value: event.value,
              ),
            ),
        onNetworkError:
            (event) => port.send(
              IsolateSnapshot(
                id: task.id,
                status: IsolateStatus.networkError,
                value: event.value,
              ),
            ),
        onPaused:
            (event) => port.send(
              IsolateSnapshot(
                id: task.id,
                status: IsolateStatus.paused,
                value: event.value,
              ),
            ),
        onProgress:
            (event) => port.send(
              IsolateSnapshot(
                id: task.id,
                status: IsolateStatus.processing,
                value: event.value,
              ),
            ),
      );
    } catch (error) {
      return port.send(
        IsolateSnapshot(
          id: task.id,
          status: IsolateStatus.error,
          value: error.toString(),
        ),
      );
    }
  }

  Future<void> isolate(IsolateTask task) async {
    final isolate = _isolates[task.id];
    if (isolate != null) return;
    _isolates[task.id] = await Isolate.spawn(_task, {
      "port": _port.sendPort,
      "task": task,
    });
  }

  void dispose() {
    _port.close();
    if (_isolates.isNotEmpty) {
      for (Isolate isolate in _isolates.values) {
        isolate.kill(priority: Isolate.immediate);
      }
    }
  }
}

class InAppUploaderIsolate extends StatefulWidget {
  final String isolate;
  final IsolateTask task;
  final void Function(BuildContext context, String value) uploaded;
  final Widget Function(
    BuildContext context,
    IsolateSnapshot snapshot,
    VoidCallback callback,
  )
  builder;

  const InAppUploaderIsolate({
    super.key,
    required this.isolate,
    required this.task,
    required this.uploaded,
    required this.builder,
  });

  @override
  State<InAppUploaderIsolate> createState() => _InAppUploaderIsolateState();
}

class _InAppUploaderIsolateState extends State<InAppUploaderIsolate> {
  late UploadIsolation isolation = UploadIsolation.of(widget.isolate);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_isolate);
  }

  void _isolate([_]) => isolation.isolate(widget.task);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isolation.snapshotOf(widget.task.id),
      builder: (context, value, child) {
        if (value.status == IsolateStatus.done) {
          widget.uploaded(context, value.value);
        }
        return widget.builder(context, value, _isolate);
      },
    );
  }
}
