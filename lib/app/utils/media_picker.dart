import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../roots/contents/media.dart';

/// Class providing methods for interacting with media (images, videos, etc.)
class MediaPicker {
  MediaPicker._();

  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();

  /// Singleton instance of MediaProvider
  static MediaPicker? _i;

  static MediaPicker get I => _i ??= MediaPicker._();

  /// Methods for cropping media
  Future<MediaData?> _fileCrop(CroppedFile? data) async {
    if (data != null) {
      final raw = kIsWeb ? "" : data.path;
      return MediaData(
        extension: Media.imageExt(pathOrMimeType: raw),
        path: data.path,
        bytes: await data.readAsBytes(),
      );
    } else {
      return null;
    }
  }

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
  Future<MediaData?> chooseImage({
    ImageSource source = ImageSource.gallery,
    bool crop = false,
    CropOptions cropOptions = const CropOptions(),
  }) {
    return _picker.pickImage(source: source).then(_filePick).then((value) {
      if (crop && value != null && value.isFile) {
        return cropImage(path: value.path ?? "", options: cropOptions);
      } else {
        return value;
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
  Future<MediaData?> cropImage({
    required String path,
    BuildContext? context,
    String title = "Edit",
    Color? foregroundColor = Colors.white,
    Color? backgroundColor = Colors.black,
    double? frameRatioX,
    double? frameRatioY,
    CropOptions? options,
  }) {
    options ??= CropOptions(
      context: context,
      title: title,
      aspectRatio: frameRatioX != null && frameRatioY != null
          ? CropAspectRatio(ratioX: frameRatioX, ratioY: frameRatioY)
          : null,
      uiSettingsAndroid: AndroidUiSettings(
        toolbarColor: backgroundColor,
        toolbarTitle: title,
        toolbarWidgetColor: foregroundColor,
        backgroundColor: backgroundColor,
        hideBottomControls: true,
        lockAspectRatio: frameRatioX != null && frameRatioY != null,
        cropFrameColor: Colors.white24,
        cropGridColor: Colors.white12,
      ),
      uiSettingsIos: IOSUiSettings(title: title),
    );
    return _cropper
        .cropImage(
          sourcePath: path,
          compressFormat: options.compressFormat,
          aspectRatio: options.aspectRatio,
          compressQuality: options.compressQuality,
          maxHeight: options.maxHeight,
          maxWidth: options.maxWidth,
          uiSettings: options.uiSettings,
        )
        .then(_fileCrop);
  }

  /// Methods for recover image
  Future<MediaData?> recoverImage() => _cropper.recoverImage().then(_fileCrop);
}

/// Class representing options for cropping images
class CropOptions {
  final BuildContext? context;
  final String? title;
  final int? maxWidth;
  final int? maxHeight;
  final CropAspectRatio? aspectRatio;
  final List<CropAspectRatioPreset> aspectRatioPresets;
  final CropStyle cropStyle;
  final ImageCompressFormat compressFormat;
  final int compressQuality;
  final AndroidUiSettings? _uiSettingsAndroid;
  final IOSUiSettings? _uiSettingsIos;
  final WebUiSettings? _uiSettingsWeb;

  AndroidUiSettings? get uiSettingsAndroid {
    final theme = context != null ? Theme.of(context!) : null;
    return _uiSettingsAndroid ??
        AndroidUiSettings(
          toolbarColor: theme?.scaffoldBackgroundColor,
          statusBarColor: theme?.scaffoldBackgroundColor,
          toolbarWidgetColor: theme?.appBarTheme.titleTextStyle?.color,
          backgroundColor: theme?.scaffoldBackgroundColor,
          cropFrameColor: Colors.white54,
          toolbarTitle: title,
          hideBottomControls: true,
          dimmedLayerColor: theme?.scaffoldBackgroundColor,
          lockAspectRatio: false,
        );
  }

  IOSUiSettings? get uiSettingsIos {
    return _uiSettingsIos;
  }

  WebUiSettings? get uiSettingsWeb {
    return _uiSettingsWeb;
  }

  List<PlatformUiSettings> get uiSettings {
    return [
      if (uiSettingsAndroid != null) uiSettingsAndroid!,
      if (uiSettingsIos != null) uiSettingsIos!,
      if (uiSettingsWeb != null) uiSettingsWeb!,
    ];
  }

  const CropOptions({
    this.context,
    this.aspectRatio,
    this.aspectRatioPresets = const [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9,
    ],
    this.compressFormat = ImageCompressFormat.jpg,
    this.compressQuality = 90,
    this.cropStyle = CropStyle.rectangle,
    this.maxWidth,
    this.maxHeight,
    this.title,
    AndroidUiSettings? uiSettingsAndroid,
    IOSUiSettings? uiSettingsIos,
    WebUiSettings? uiSettingsWeb,
  }) : _uiSettingsAndroid = uiSettingsAndroid,
       _uiSettingsIos = uiSettingsIos,
       _uiSettingsWeb = uiSettingsWeb;
}
