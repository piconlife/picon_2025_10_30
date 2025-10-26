import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../../roots/services/storage.dart';

class InAppStorageDelegate extends StorageDelegate {
  @override
  Future<StorageResponse<bool>> delete(String url) {
    return FirebaseStorage.instance
        .refFromURL(url)
        .delete()
        .then((value) => const StorageResponse(data: true))
        .onError((e, st) {
          return StorageResponse(error: "$e");
        });
  }

  @override
  Future<StorageResponse<Uint8List>> download(
    String url, {
    int byteQuality = 10485760,
  }) {
    return FirebaseStorage.instance
        .refFromURL(url)
        .getData(byteQuality)
        .onError((e, st) => null)
        .then((value) => StorageResponse(data: value));
  }

  double _uploadProgress(TaskSnapshot snapshot) {
    final transferred = snapshot.bytesTransferred;
    final total = snapshot.totalBytes;
    final progress = 100.0 * (transferred / total);
    return progress;
  }

  Reference _uploadReference(String path, String filename) {
    return FirebaseStorage.instance.ref(path).child(filename);
  }

  UploadTask _uploadTask(
    String path,
    dynamic data,
    Reference reference, {
    SettableMetadata? metadata,
    UploadStringFormat format = UploadStringFormat.raw,
    UploadDataType? type,
  }) {
    final mType = type ?? UploadDataType.from(data);
    switch (mType) {
      case UploadDataType.blob:
        return reference.putBlob(data, metadata);
      case UploadDataType.bytes:
        return reference.putData(data, metadata);
      case UploadDataType.file:
        return reference.putFile(data, metadata);
      case UploadDataType.string:
        return reference.putString(
          data,
          format:
              PutStringFormat.values
                  .where((e) => e.name == format.name)
                  .firstOrNull ??
              PutStringFormat.raw,
          metadata: metadata,
        );
    }
  }

  @override
  void upload(
    String path,
    UploadingFile data, {
    UploadStringFormat format = UploadStringFormat.raw,
    void Function(UploadEvent<bool> event)? onCanceled,
    void Function(UploadEvent<String> event)? onDone,
    void Function(UploadEvent<String> event)? onError,
    void Function(UploadEvent<bool> event)? onLoading,
    void Function(UploadEvent<bool> event)? onNetworkError,
    void Function(UploadEvent<bool> event)? onPaused,
    void Function(UploadEvent<double> event)? onProgress,
  }) {
    final id = data.tag;
    final reference = _uploadReference(path, data.filename);
    _uploadTask(
          path,
          data.data,
          reference,
          type: data.type,
          format: format,
          metadata: SettableMetadata(contentType: data.mimeType),
        ).snapshotEvents
        .listen((event) {
          switch (event.state) {
            case TaskState.canceled:
              onLoading?.call(UploadEvent(id: id, value: false));
              onCanceled?.call(UploadEvent(id: id, value: true));
              break;
            case TaskState.error:
              onLoading?.call(UploadEvent(id: id, value: false));
              onError?.call(
                UploadEvent(id: id, value: "Something went wrong!"),
              );
              break;
            case TaskState.paused:
              onLoading?.call(UploadEvent(id: id, value: false));
              onPaused?.call(UploadEvent(id: id, value: true));
              break;
            case TaskState.running:
              onProgress?.call(
                UploadEvent(id: data.tag, value: _uploadProgress(event)),
              );
              break;
            case TaskState.success:
              reference
                  .getDownloadURL()
                  .then((url) {
                    onLoading?.call(UploadEvent(id: id, value: false));
                    onDone?.call(UploadEvent(id: id, value: url));
                  })
                  .catchError((error) {
                    onLoading?.call(UploadEvent(id: id, value: false));
                    onError?.call(UploadEvent(id: id, value: "$error"));
                  });
              break;
          }
        })
        .onError((error) {
          onLoading?.call(UploadEvent(id: id, value: false));
          onError?.call(UploadEvent(id: id, value: "$error"));
        });
  }

  @override
  Future<StorageResponse<String>> uploadRequest(
    String path,
    UploadingFile data, {
    UploadStringFormat format = UploadStringFormat.raw,
  }) {
    final reference = _uploadReference(path, data.filename);
    return _uploadTask(
          path,
          data.data,
          reference,
          format: format,
          type: data.type,
          metadata: SettableMetadata(contentType: data.extension),
        )
        .then((_) {
          return reference.getDownloadURL().then((value) {
            return StorageResponse(data: value);
          });
        })
        .catchError((error) {
          return StorageResponse<String>(error: "$error");
        });
  }
}
