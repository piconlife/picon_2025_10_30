import 'package:flutter/material.dart';

import '../../app/contents/media.dart';
import 'storage.dart';

class UploadingTask {
  final String id;
  final String path;
  final MediaData data;

  const UploadingTask({
    required this.id,
    required this.path,
    required this.data,
  });
}

class UploadingSnapshot {
  final String id;
  final UploadingStatus status;
  final dynamic value;

  String? get url {
    return status == UploadingStatus.done && value is String
        ? value as String
        : null;
  }

  const UploadingSnapshot({
    this.id = "",
    this.status = UploadingStatus.initial,
    this.value,
  });

  UploadingSnapshot copy({String? id, UploadingStatus? status, dynamic value}) {
    return UploadingSnapshot(
      id: id ?? this.id,
      status: status ?? this.status,
      value: value ?? this.value,
    );
  }
}

enum UploadingStatus {
  initial,
  loading,
  progressing,
  processing,
  processed,
  networkError,
  canceled,
  error,
  paused,
  done,
}

class Uploader extends ValueNotifier<UploadingSnapshot> {
  static final Map<String, Uploader> _proxies = {};

  static Uploader of(String id) => _proxies[id] ??= Uploader._(id);

  final String id;

  Uploader._(this.id) : super(UploadingSnapshot(id: id));

  void notify(UploadingSnapshot snapshot) => value = snapshot;

  void upload(UploadingTask task) {
    try {
      final data = task.data;
      StorageService.i.upload(
        task.path,
        UploadingFile(
          data: data.data,
          extension: data.extension,
          filename: "${task.id}.${data.extension ?? "jpg"}",
        ),
        onCanceled:
            (event) => notify(
              UploadingSnapshot(
                id: task.id,
                status: UploadingStatus.canceled,
                value: event.value,
              ),
            ),
        onDone:
            (event) => notify(
              UploadingSnapshot(
                id: task.id,
                status: UploadingStatus.done,
                value: event.value,
              ),
            ),
        onError:
            (event) => notify(
              UploadingSnapshot(
                id: task.id,
                status: UploadingStatus.error,
                value: event.value,
              ),
            ),
        onLoading:
            (event) => notify(
              UploadingSnapshot(
                id: task.id,
                status: UploadingStatus.loading,
                value: event.value,
              ),
            ),
        onNetworkError:
            (event) => notify(
              UploadingSnapshot(
                id: task.id,
                status: UploadingStatus.networkError,
                value: event.value,
              ),
            ),
        onPaused:
            (event) => notify(
              UploadingSnapshot(
                id: task.id,
                status: UploadingStatus.paused,
                value: event.value,
              ),
            ),
        onProgress:
            (event) => notify(
              UploadingSnapshot(
                id: task.id,
                status: UploadingStatus.progressing,
                value: event.value,
              ),
            ),
      );
    } catch (error) {
      notify(
        UploadingSnapshot(
          id: task.id,
          status: UploadingStatus.error,
          value: error.toString(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _proxies.remove(id);
    super.dispose();
  }
}

typedef InAppUploaderProcessingCallback =
    Future<UploadingStatus> Function(
      BuildContext context,
      UploadingSnapshot value,
    );
typedef InAppUploaderBuilder =
    Widget Function(
      BuildContext context,
      UploadingSnapshot snapshot,
      VoidCallback callback,
    );

class InAppUploader extends StatefulWidget {
  final UploadingTask task;
  final InAppUploaderProcessingCallback onProcessing;
  final InAppUploaderBuilder builder;

  const InAppUploader({
    super.key,
    required this.task,
    required this.builder,
    required this.onProcessing,
  });

  @override
  State<InAppUploader> createState() => _InAppUploaderState();
}

class _InAppUploaderState extends State<InAppUploader> {
  late Uploader uploader = Uploader.of(widget.task.id);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_upload);
  }

  @override
  void dispose() {
    uploader.dispose();
    super.dispose();
  }

  void _upload([_]) => uploader.upload(widget.task);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: uploader,
      builder: (context, value, _) {
        if (value.status == UploadingStatus.done) {
          return FutureBuilder(
            future: widget.onProcessing(context, value),
            builder: (context, snapshot) {
              final status = snapshot.data;
              return widget.builder(
                context,
                value.copy(status: status),
                _upload,
              );
            },
          );
        }
        return widget.builder(context, value, _upload);
      },
    );
  }
}
