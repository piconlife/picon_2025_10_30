import 'dart:io';

import 'package:flutter/foundation.dart';

enum UploadDataType {
  blob,
  bytes,
  file,
  string;

  bool get isBlob => this == blob;

  bool get isBytes => this == bytes;

  bool get isFile => this == file;

  bool get isString => this == string;

  factory UploadDataType.from(dynamic data) {
    if (data is Uint8List || data is List<int>) {
      return UploadDataType.bytes;
    } else if (data is File) {
      return UploadDataType.file;
    } else if (data is String) {
      return UploadDataType.string;
    } else {
      return UploadDataType.blob;
    }
  }
}

enum UploadStringFormat {
  /// A raw string. It will be uploaded as a Base64 string.
  raw,

  /// A Base64 encoded string.
  base64,

  /// A Base64 URL encoded string.
  base64Url,

  /// A data url string.
  dataUrl,
}

class UploadingFile {
  final dynamic data;
  final String filename;
  final String? mimeType;
  final String? extension;
  final String? tag;
  final UploadDataType? type;

  const UploadingFile({
    required this.data,
    required this.filename,
    this.mimeType,
    this.extension,
    this.tag,
    this.type,
  });

  @override
  String toString() {
    return "$UploadingFile(data: $data, filename: $filename, extension: $extension, mimeType: $mimeType, tag: $tag, type: $type)";
  }
}

class UploadedFile {
  final dynamic data;
  final String filename;
  final String? extension;
  final String? exception;
  final String? tag;
  final UploadDataType? type;
  final String? url;

  bool get isUploaded => url != null && url!.isNotEmpty;

  bool get isFailed => exception != null && exception!.isNotEmpty;

  const UploadedFile({
    required this.data,
    required this.filename,
    this.extension,
    this.exception,
    this.tag,
    this.type,
    this.url,
  });

  factory UploadedFile._with(UploadingFile uploadingFile) {
    return UploadedFile(
      data: uploadingFile.data,
      filename: uploadingFile.filename,
      extension: uploadingFile.extension,
      tag: uploadingFile.tag,
      type: uploadingFile.type,
    );
  }

  UploadedFile copyWith({
    dynamic data,
    String? filename,
    String? extension,
    String? exception,
    String? tag,
    UploadDataType? type,
    String? url,
  }) {
    return UploadedFile(
      data: data ?? this.data,
      filename: filename ?? this.filename,
      extension: extension ?? this.extension,
      exception: exception ?? this.exception,
      tag: tag ?? this.tag,
      type: type ?? this.type,
      url: url ?? this.url,
    );
  }

  @override
  String toString() {
    return "$UploadedFile(data: $data, filename: $filename, extension: $extension, tag: $tag, type: $type, url: $url)";
  }
}

abstract class StorageEvent {
  final Object? id;

  const StorageEvent({this.id});

  @override
  String toString() {
    return "$StorageEvent(id: $id)";
  }
}

class DownloadEvent extends StorageEvent {
  const DownloadEvent({required super.id});

  @override
  String toString() {
    return "$DownloadEvent(id: $id)";
  }
}

class UploadEvent<T extends Object> extends StorageEvent {
  final T value;

  const UploadEvent({required super.id, required this.value});

  @override
  String toString() {
    return "$UploadEvent(id: $id, value: $value)";
  }
}

class StorageResponse<T extends Object> {
  final bool loading;
  final bool successful;
  final bool networkError;
  final String? error;
  final T? data;

  const StorageResponse({
    this.loading = false,
    this.networkError = false,
    this.error,
    this.data,
  }) : successful = data != null;

  List<String> get urls {
    final x = data;
    if (x is List<String>) {
      return x.where((e) => e.isNotEmpty).toList();
    } else {
      return [];
    }
  }

  @override
  String toString() {
    return "$StorageResponse(loading: $loading, successful: $successful, networkError: $networkError, error: $error, data: $data)";
  }
}

abstract class StorageDelegate {
  Future<StorageResponse<bool>> delete(String url);

  Future<StorageResponse<Uint8List>> download(
    String url, {
    int byteQuality = 10485760,
  });

  Future<StorageResponse<String>> uploadRequest(
    String path,
    UploadingFile data, {
    UploadStringFormat format = UploadStringFormat.raw,
  });

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
  });
}

class StorageService {
  final Future<bool> isConnected;
  final StorageDelegate delegate;

  final _tempUrls = <String>[];

  StorageService._(this.isConnected, this.delegate);

  static StorageService? _i;

  static StorageService get i {
    final x = _i;
    if (x != null) {
      return x;
    } else {
      throw UnimplementedError("$StorageService not implemented yet!");
    }
  }

  static StorageService get I => i;

  static StorageService get instance => i;

  static void init({
    required StorageDelegate delegate,
    required Future<bool> connectionStatus,
  }) {
    _i ??= StorageService._(connectionStatus, delegate);
  }

  bool isComplete(int initial, int progress) => initial == progress;

  Future<StorageResponse<bool>> delete(String url) {
    return isConnected.then((connected) {
      if (connected) {
        return delegate
            .delete(url)
            .then((_) {
              return const StorageResponse(data: true);
            })
            .onError((error, stackTrace) {
              return StorageResponse(error: "$error");
            });
      } else {
        return const StorageResponse(networkError: true);
      }
    });
  }

  Future<StorageResponse<bool>> deletes(
    List<String> urls, {
    bool lazy = false,
  }) {
    if (urls.isEmpty) {
      return Future.value(const StorageResponse(error: "Empty list!"));
    }
    return isConnected.then((connected) async {
      if (connected) {
        _tempUrls.clear();
        for (var url in urls) {
          if (lazy) {
            delegate.delete(url).then((value) => _tempUrls.add("null"));
          } else {
            await delegate.delete(url).then((value) => _tempUrls.add("null"));
          }
        }
        return StorageResponse(data: isComplete(urls.length, _tempUrls.length));
      } else {
        return const StorageResponse(networkError: true);
      }
    });
  }

  Future<StorageResponse<Uint8List>> download({
    required String url,
    int byteQuality = 10485760,
  }) {
    return isConnected.then((connected) {
      if (connected) {
        return delegate.download(url, byteQuality: byteQuality).onError((
          e,
          st,
        ) {
          return StorageResponse(error: e.toString());
        });
      } else {
        return const StorageResponse(networkError: true);
      }
    });
  }

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
    onLoading?.call(UploadEvent(id: id, value: true));
    isConnected.then((connected) {
      if (connected) {
        delegate.upload(
          path,
          data,
          format: format,
          onCanceled: onCanceled,
          onDone: onDone,
          onError: onError,
          onLoading: onLoading,
          onNetworkError: onNetworkError,
          onPaused: onPaused,
          onProgress: onProgress,
        );
      } else {
        onLoading?.call(UploadEvent(id: id, value: false));
        onNetworkError?.call(UploadEvent(id: id, value: true));
      }
    });
  }

  void uploads(
    String path,
    List<UploadingFile> data, {
    UploadStringFormat format = UploadStringFormat.raw,
    void Function(UploadEvent<bool> event)? onItemCanceled,
    void Function(UploadEvent<String> event)? onItemDone,
    void Function(UploadEvent<String> event)? onItemError,
    void Function(UploadEvent<bool> event)? onItemLoading,
    void Function(UploadEvent<bool> event)? onItemNetworkError,
    void Function(UploadEvent<bool> event)? onItemPaused,
    void Function(UploadEvent<double> event)? onItemProgress,
    void Function(StorageResponse<List<String>> response)? onResponse,
  }) {
    isConnected.then((connected) {
      if (connected) {
        _tempUrls.clear();
        onResponse?.call(const StorageResponse(loading: true));
        for (var item in data) {
          upload(
            path,
            item,
            format: format,
            onCanceled: (event) {
              _tempUrls.add("");
              if (onItemCanceled != null) onItemCanceled(event);
              if (onResponse != null) {
                if (isComplete(data.length, _tempUrls.length)) {
                  onResponse(StorageResponse(data: _tempUrls, loading: false));
                }
              }
            },
            onError: (event) {
              _tempUrls.add("");
              if (onItemError != null) onItemError(event);
              if (onResponse != null) {
                if (isComplete(data.length, _tempUrls.length)) {
                  onResponse(StorageResponse(data: _tempUrls, loading: false));
                }
              }
            },
            onNetworkError: (event) {
              _tempUrls.add("");
              if (onItemNetworkError != null) onItemNetworkError(event);
              if (onResponse != null) {
                if (isComplete(data.length, _tempUrls.length)) {
                  onResponse(StorageResponse(data: _tempUrls, loading: false));
                }
              }
            },
            onPaused: (event) {
              _tempUrls.add("");
              if (onItemPaused != null) onItemPaused(event);
              if (onResponse != null) {
                if (isComplete(data.length, _tempUrls.length)) {
                  onResponse(StorageResponse(data: _tempUrls, loading: false));
                }
              }
            },
            onProgress: onItemProgress,
            onDone: (event) {
              _tempUrls.add(event.value);
              if (onItemDone != null) onItemDone(event);
              if (onResponse != null) {
                if (isComplete(data.length, _tempUrls.length)) {
                  onResponse(StorageResponse(data: _tempUrls, loading: false));
                }
              }
            },
          );
        }
      } else {
        if (onResponse != null) {
          onResponse(const StorageResponse(loading: false));
        }
      }
    });
  }

  Future<StorageResponse<UploadedFile>> uploadRequest(
    String path,
    UploadingFile data, {
    UploadStringFormat format = UploadStringFormat.raw,
  }) {
    return isConnected.then((connected) {
      if (connected) {
        return delegate.uploadRequest(path, data, format: format).then((value) {
          final url = value.data ?? '';
          return StorageResponse(
            data: UploadedFile._with(data).copyWith(
              url: url.isEmpty ? null : url,
              exception: url.isEmpty ? value.error : null,
            ),
          );
        });
      } else {
        return const StorageResponse(networkError: true);
      }
    });
  }

  Future<StorageResponse<List<UploadedFile>>> uploadRequests(
    String path,
    Iterable<UploadingFile> data, {
    UploadStringFormat format = UploadStringFormat.raw,
  }) {
    return isConnected.then((connected) async {
      if (connected) {
        return Future.wait(
          data.map((e) {
            return uploadRequest(path, e, format: format).then((value) {
              return value.data ??
                  UploadedFile._with(
                    e,
                  ).copyWith(exception: "Error uploading file!");
            });
          }),
        ).then((value) {
          return StorageResponse(data: value);
        });
      } else {
        return const StorageResponse(networkError: true);
      }
    });
  }
}
