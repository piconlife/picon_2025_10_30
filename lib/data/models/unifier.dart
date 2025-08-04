import 'package:flutter_andomie/core.dart';
import 'package:flutter_entity/flutter_entity.dart';

class UnifierKeys extends EntityKey {
  final value = "value";
  final verified = "verified";

  const UnifierKeys._();

  static UnifierKeys? _i;

  static UnifierKeys get i => _i ??= const UnifierKeys._();
}

abstract class Unifier extends Entity<UnifierKeys> {
  final String? value;
  final bool? verified;

  Unifier({super.timeMills, this.value, this.verified})
    : super(id: identifier(value));

  static String identifier(String? value) {
    value ??= "";
    if (value.startsWith("+")) {
      value = value.replaceAll("+", "");
    }
    return Replacement.auto(value, '_');
  }

  @override
  UnifierKeys makeKey() => UnifierKeys.i;

  @override
  Map<String, dynamic> get source {
    return {
      key.timeMills: timeMills,
      if (value != null) key.value: value,
      if (verified ?? false) key.verified: verified,
    };
  }
}

class NameUnifier extends Unifier {
  NameUnifier({super.timeMills, super.value, super.verified});

  factory NameUnifier.from(Object? source) {
    return NameUnifier(
      timeMills: source.entityValue(UnifierKeys.i.timeMills),
      value: source.entityValue(UnifierKeys.i.value),
      verified: source.entityValue(UnifierKeys.i.verified),
    );
  }
}

class PrefixUnifier extends Unifier {
  PrefixUnifier({super.timeMills, super.value, super.verified});

  factory PrefixUnifier.from(Object? source) {
    return PrefixUnifier(
      timeMills: source.entityValue(UnifierKeys.i.timeMills),
      value: source.entityValue(UnifierKeys.i.value),
      verified: source.entityValue(UnifierKeys.i.verified),
    );
  }
}

class PhoneUnifier extends Unifier {
  PhoneUnifier({super.timeMills, super.value, super.verified});

  factory PhoneUnifier.from(Object? source) {
    return PhoneUnifier(
      timeMills: source.entityValue(UnifierKeys.i.timeMills),
      value: source.entityValue(UnifierKeys.i.value),
      verified: source.entityValue(UnifierKeys.i.verified),
    );
  }
}
