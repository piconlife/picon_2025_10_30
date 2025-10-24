import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';

/// Enumeration of supported media extensions
enum MediaExtensions {
  /// Provide audio extensions
  audio([
    "mp3",
    "wav",
    "ogg",
    "flac",
    "ac",
    "aac",
    "wma",
    "m4a",
    "opus",
    "amr",
    "mid",
    "midi",
    "weba",
  ]),

  /// Provide document extensions
  document([
    "doc",
    "docx",
    "pdf",
    "txt",
    "rtf",
    "odt",
    "odp",
    "ods",
    "ppt",
    "pptx",
    "xls",
    "xlsx",
  ]),

  /// Provide image extensions
  image([
    "jpg",
    "jpeg",
    "png",
    "gif",
    "bmp",
    "tiff",
    "webp",
    "svg",
    "ico",
    "jfif",
    "pjpeg",
    "pjp",
  ]),

  /// Provide video extensions
  video([
    "mp4",
    "mkv",
    "avi",
    "mov",
    "wmv",
    "flv",
    "webm",
    "m4v",
    "3gp",
    "mpeg",
    "mpg",
    "ogv",
  ]);

  /// Provide all media extensions
  final List<String> value;

  /// Constructor of MediaExtensions
  const MediaExtensions(this.value);

  List<String> get extensions {
    final ex = <String>[];
    for (var element in values) {
      ex.addAll(element.value);
    }
    return ex;
  }

  static bool isAudioExt(String? extension) {
    return audio.value.contains(extension);
  }

  static bool isDocumentExt(String? extension) {
    return document.value.contains(extension);
  }

  static bool isImageExt(String? extension) {
    return image.value.contains(extension);
  }

  static bool isVideoExt(String? extension) {
    return video.value.contains(extension);
  }

  static String? prefix(String? extension) {
    if (MediaExtensions.isAudioExt(extension)) {
      return "aud";
    } else if (MediaExtensions.isDocumentExt(extension)) {
      return "doc";
    } else if (MediaExtensions.isImageExt(extension)) {
      return "img";
    } else if (MediaExtensions.isVideoExt(extension)) {
      return "vid";
    } else {
      return null;
    }
  }
}

class MediaData {
  const MediaData({
    this.blob,
    this.extension,
    this.mimeType,
    this.path,
    this.url,
    Uint8List? bytes,
    String? name,
  }) : _bytes = bytes,
       _name = name;

  final dynamic blob;
  final Uint8List? _bytes;
  final String? extension;
  final String? mimeType;
  final String? _name;
  final String? path;
  final String? url;

  /// Methods to check blob validation
  bool get isBlob => blob != null;

  /// Methods to check byte validation
  bool get isByte => _bytes != null && _bytes.isNotEmpty;

  /// Methods to check file validation
  bool get isFile => path != null && path!.isNotEmpty;

  /// Getter methods to determine the type of media data
  Uint8List get bytes => isByte ? _bytes! : Uint8List(0);

  /// Getter methods to determine the type of media data
  Object? get data {
    if (isByte) {
      return bytes;
    } else if (!kIsWeb && isFile) {
      return File(path!);
    } else {
      return blob;
    }
  }

  /// Getter methods to determine the type of media data
  File get file => isFile && !kIsWeb ? File(path!) : File("");

  /// Getter methods to determine the type of media data
  Uri get uri => isFile && !kIsWeb ? Uri.file(path!) : Uri();

  /// Methods to calculate file sizes in KB
  double get sizeAsKb => bytes.length / 1024;

  /// Methods to calculate file sizes in MB
  double get sizeAsMb => sizeAsKb / 1024;

  /// Methods to calculate file sizes in GB
  double get sizeAsGb => sizeAsMb / 1024;

  /// Getter method to generate a filename based on properties
  String get customFilename {
    return Media.toFilename(
      extension: extension,
      path: path,
      prefix: prefix,
      root: false,
    );
  }

  /// Getter methods to find media name
  String get filename => Media.toFilename(extension: extension, path: path);

  /// Getter methods to determine the type of media data
  String get prefix {
    final ex = extension ?? Media.getExtension(path);
    return MediaExtensions.prefix(ex) ?? "";
  }

  Map<String, dynamic> get source {
    return {
      "blob": blob,
      "bytes": _bytes,
      "extension": extension,
      "mimeType": mimeType,
      "name": _name,
      "path": path,
      "url": url,
    };
  }

  String get json => jsonEncode(source);

  @override
  int get hashCode =>
      blob.hashCode ^
      _bytes.hashCode ^
      extension.hashCode ^
      mimeType.hashCode ^
      _name.hashCode ^
      path.hashCode ^
      url.hashCode;

  @override
  bool operator ==(Object other) {
    return other is MediaData &&
        other.blob == blob &&
        other._bytes == _bytes &&
        other.extension == extension &&
        other.mimeType == mimeType &&
        other._name == _name &&
        other.path == path &&
        other.url == url;
  }

  /// Methods to copy for necessary properties change
  MediaData copy({
    dynamic blob,
    Uint8List? bytes,
    String? extension,
    String? mimeType,
    String? name,
    String? path,
    String? url,
  }) {
    return MediaData(
      blob: blob ?? this.blob,
      bytes: bytes ?? _bytes,
      extension: extension ?? this.extension,
      mimeType: mimeType ?? this.mimeType,
      name: name ?? _name,
      path: path ?? this.path,
      url: url ?? this.url,
    );
  }

  @override
  String toString() => "$MediaData#$hashCode($json)";
}

/// Class providing methods for interacting with media (images, videos, etc.)
class Media {
  Media._();

  /// Static methods to extract filename prefix
  static String? getPrefix(String? path) {
    if (path == null || path.isEmpty) return null;
    return MediaExtensions.prefix(getExtension(path));
  }

  static String? getNameWithoutExtension(String? path) {
    if (path == null || path.isEmpty) return null;
    final x = path.split("/").lastOrNull ?? "";
    final dotIndex = x.isNotEmpty ? x.lastIndexOf('.') : -1;
    return dotIndex != -1 ? x.substring(0, dotIndex) : null;
  }

  /// Static methods to extract filename extension
  static String? getExtension(String? path, {bool fromMime = false}) {
    if (path == null || path.isEmpty) return null;
    final x = path.split("/").lastOrNull ?? "";
    if (fromMime) {
      return x.isNotEmpty ? x : null;
    } else {
      final dotIndex = x.isNotEmpty ? x.lastIndexOf('.') : -1;
      return dotIndex != -1 ? x.substring(dotIndex + 1) : null;
    }
  }

  /// Static methods to check if prefix is valid
  static bool isValidPrefix(String? path) {
    final prefix = getNameWithoutExtension(path);
    return prefix != null && prefix.isNotEmpty;
  }

  /// Static methods to check if extension is valid
  static bool isValidExtension(String? path, {bool fromMime = false}) {
    final extension = getExtension(path, fromMime: fromMime);
    return extension != null && extension.isNotEmpty;
  }

  /// Static method to generate random numbers
  static String getRandomNumbers(int size) {
    Random random = Random();
    String randomNumber = '';
    for (int i = 0; i < size; i++) {
      randomNumber += random.nextInt(10).toString();
    }
    return randomNumber;
  }

  /// Static method to generate a filename with date, prefix, and random numbers
  static String toFilename({
    String? path,
    String? extension,
    String? prefix,
    String separator = "_",
    bool root = true,
    bool extensionFromMime = false,
  }) {
    final mName = getNameWithoutExtension(path) ?? "";
    final mExtension = getExtension(path, fromMime: extensionFromMime) ?? "";
    if (root && mName.isNotEmpty && mExtension.isNotEmpty) {
      return '$mName.$mExtension';
    } else {
      final ex = extension ?? mExtension;
      final dot = ex.isNotEmpty ? "." : "";
      final pre = getPrefix(path) ?? "";
      final sep = pre.isNotEmpty ? separator : "";
      final randoms = getRandomNumbers(5);

      final now = DateTime.now();
      final y = now.year.toString().padLeft(4, '0');
      final m = now.month.toString().padLeft(2, '0');
      final d = now.day.toString().padLeft(2, '0');
      final h = now.hour.toString().padLeft(2, '0');
      final min = now.minute.toString().padLeft(2, '0');
      final s = now.second.toString().padLeft(2, '0');

      final formatted = "$y$m$d$sep$h$min$s";
      return '$pre$sep$formatted$randoms$dot$ex';
    }
  }

  /// Method to get the file extension based on supported extensions
  static String? extension({
    required String? pathOrMimeType,
    required MediaExtensions extensions,
    List<String>? customExtensions,
  }) {
    final raw = pathOrMimeType ?? "";
    final current = customExtensions ?? extensions.value;
    final isSupportedExtension = current.any((ext) {
      return raw.contains("/$ext") || raw.contains(".$ext");
    });
    if (isSupportedExtension) {
      return current.firstWhere((ext) {
        return raw.contains("/$ext") || raw.contains(".$ext");
      });
    } else {
      return null;
    }
  }

  /// Methods to get specific audio extension
  static String? audioExt({
    required String? pathOrMimeType,
    List<String>? extensions,
  }) {
    return extension(
      pathOrMimeType: pathOrMimeType,
      extensions: MediaExtensions.audio,
      customExtensions: extensions,
    );
  }

  /// Methods to get specific document extension
  static String? documentExt({
    required String? pathOrMimeType,
    List<String>? extensions,
  }) {
    return extension(
      pathOrMimeType: pathOrMimeType,
      extensions: MediaExtensions.document,
      customExtensions: extensions,
    );
  }

  /// Methods to get specific image extension
  static String? imageExt({
    required String? pathOrMimeType,
    List<String>? extensions,
  }) {
    return extension(
      pathOrMimeType: pathOrMimeType,
      extensions: MediaExtensions.image,
      customExtensions: extensions,
    );
  }

  /// Methods to get specific video extension
  static String? videoExt({
    required String? pathOrMimeType,
    List<String>? extensions,
  }) {
    return extension(
      pathOrMimeType: pathOrMimeType,
      extensions: MediaExtensions.video,
      customExtensions: extensions,
    );
  }
}
