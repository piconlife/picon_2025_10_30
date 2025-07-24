import '../../../roots/data/constants/keys.dart';

class Keys extends RootKeys {
  const Keys._();

  static Keys? _i;

  static Keys get i => _i ??= const Keys._();

  @override
  Iterable<String> get keys {
    return [...super.keys];
  }
}
