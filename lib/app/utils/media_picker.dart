import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../roots/contents/media.dart';
import '../dialogs/dialog_image_cropper.dart';

/// Class providing methods for interacting with media (images, videos, etc.)
class MediaPicker {
  MediaPicker._();

  final ImagePicker _picker = ImagePicker();

  /// Singleton instance of MediaProvider
  static MediaPicker? _i;

  static MediaPicker get I => _i ??= MediaPicker._();

  /// Methods for choosing media
  Future<MediaData?> _filePick(XFile? data) async {
    if (data != null) {
      final raw = kIsWeb ? data.mimeType ?? "" : data.path;
      return MediaData(
        name: data.name,
        extension: Media.imageExt(pathOrMimeType: raw),
        mimeType: data.mimeType,
        path: data.path,
        bytes: await data.readAsBytes(),
      );
    } else {
      return null;
    }
  }

  /// Methods for choosing medias
  Future<List<MediaData>> _filePicks(List<XFile> data) async {
    if (data.isNotEmpty) {
      final list = <MediaData>[];
      for (var i in data) {
        final item = await _filePick(i);
        if (item != null) list.add(item);
      }
      return list;
    } else {
      return [];
    }
  }

  /// Methods for choosing image
  Future<MediaData?> chooseImage(
    BuildContext context, {
    ImageSource source = ImageSource.gallery,
    bool crop = false,
    InAppImageCropperOptions? cropOptions,
  }) {
    return _picker.pickImage(source: source).then(_filePick).then((v) {
      if (context.mounted && crop && v != null && v.isByte) {
        return cropImage(context, v.bytes, original: v, options: cropOptions);
      } else {
        return v;
      }
    });
  }

  /// Methods for choosing images
  Future<List<MediaData>> chooseImages() async {
    return _picker.pickMultiImage().then(_filePicks);
  }

  /// Methods for choosing media
  Future<MediaData?> chooseMedia() {
    return _picker.pickMedia().then(_filePick);
  }

  /// Methods for choosing medias
  Future<List<MediaData>> chooseMedias() async {
    return _picker.pickMultipleMedia().then(_filePicks);
  }

  /// Methods for choosing video
  Future<MediaData?> chooseVideo({ImageSource source = ImageSource.gallery}) {
    return _picker.pickVideo(source: source).then(_filePick);
  }

  /// Methods for cropping image
  Future<MediaData?> cropImage(
    BuildContext context,
    Uint8List data, {
    MediaData? original,
    InAppImageCropperOptions? options,
  }) {
    return InAppImageCropper.crop(context, data, options: options).then((v) {
      if (v == null) return null;
      return (original ?? MediaData()).copy(bytes: v.cropped);
    });
  }
}
