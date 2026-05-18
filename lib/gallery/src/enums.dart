enum AssetType { other, image, video, audio }

enum GalleryType { all, image, video }

enum PermissionState { notDetermined, restricted, denied, authorized, limited }

extension PermissionStateExt on PermissionState {
  bool get isAuth => this == PermissionState.authorized;

  bool get hasAccess =>
      this == PermissionState.authorized || this == PermissionState.limited;

  bool get isLimited => this == PermissionState.limited;
}

extension StringExt on String {
  PermissionState get state => switch (this) {
    "authorized" => PermissionState.authorized,
    "limited" => PermissionState.limited,
    "denied" => PermissionState.denied,
    "restricted" => PermissionState.restricted,
    _ => PermissionState.notDetermined,
  };
}
