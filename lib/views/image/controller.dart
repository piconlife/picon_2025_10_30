part of 'view.dart';

class ImageViewController extends ViewController {
  bool cacheMode = true;

  void setCacheMode(bool value) {
    onNotifyWithCallback(() => cacheMode = value);
  }

  dynamic _image;

  set image(dynamic value) => _image = value;

  void setImage(dynamic value) {
    onNotifyWithCallback(() => image = value);
  }

  Color? imageTint;

  void setImageTint(Color? value) {
    onNotifyWithCallback(() => imageTint = value);
  }

  BlendMode? imageTintMode;

  void setImageTintMode(BlendMode value) {
    onNotifyWithCallback(() => imageTintMode = value);
  }

  ImageType _imageType = ImageType.detect;

  set imageType(ImageType value) => _imageType = value;

  void setImageType(ImageType value) {
    onNotifyWithCallback(() => imageType = value);
  }

  ImageConfigNetwork? networkImageConfig;

  void setNetworkImageConfig(ImageConfigNetwork? value) {
    onNotifyWithCallback(() => networkImageConfig = value);
  }

  dynamic placeholder;

  void setPlaceholder(dynamic value) {
    onNotifyWithCallback(() => placeholder = value);
  }

  Color? placeholderTint;

  void setPlaceholderTint(Color? value) {
    onNotifyWithCallback(() => placeholderTint = value);
  }

  BlendMode? placeholderTintMode;

  void setPlaceholderTintMode(dynamic value) {
    onNotifyWithCallback(() => placeholderTintMode = value);
  }

  ImageType _placeholderType = ImageType.detect;

  set placeholderType(ImageType value) => _placeholderType = value;

  void setPlaceholderType(ImageType value) {
    onNotifyWithCallback(() => placeholderType = value);
  }

  BoxFit? scaleType;

  void setScaleType(BoxFit? value) {
    onNotifyWithCallback(() => scaleType = value);
  }

  ImageViewController fromImageView(ImageView view) {
    super.fromView(view);
    cacheMode = view.cacheMode ?? true;
    placeholder = view.placeholder;
    placeholderTint = view.placeholderTint;
    placeholderTintMode = view.placeholderTintMode;
    scaleType = view.scaleType;
    _image = view.image;
    imageTint = view.tint;
    imageTintMode = view.tintMode;
    _imageType = view.imageType ?? ImageType.detect;
    _placeholderType = view.placeholderType ?? ImageType.detect;
    return this;
  }

  dynamic get image => isPlaceholder ? placeholder : _image;

  ImageType get type => isPlaceholder ? placeholderType : imageType;

  bool get isPlaceholder {
    final data = _image;
    final x = data is String ? data.isEmpty : false;
    final y = imageType == ImageType.detect || imageType == ImageType.unknown;
    return x || y;
  }

  ImageType get imageType => ImageType.from(_image, _imageType);

  ImageType get placeholderType {
    return ImageType.from(placeholder, _placeholderType);
  }
}
