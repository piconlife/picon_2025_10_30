class Keys {
  const Keys._();

  static Keys? _i;

  static Keys get i => _i ??= const Keys._();
}
