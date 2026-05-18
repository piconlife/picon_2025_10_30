import 'dart:typed_data';

enum FilterType {
  none(accuracy: 0.0),
  blur(accuracy: 80.0),
  darkOrLowLight(accuracy: 40.0),
  screenshot(accuracy: 0.05),
  duplicate(accuracy: 8.0),
  nudity(accuracy: 0.65),
  violence(accuracy: 0.70),
  graphic(accuracy: 0.68),
  selfie(accuracy: 0.75);

  final double accuracy;

  const FilterType({required this.accuracy});
}

class FilterRule {
  const FilterRule({
    required this.type,
    this.allow = false,
    this.lazy = false,
    double? accuracy,
  }) : _value = accuracy;

  final FilterType type;
  final bool allow;
  final bool lazy;
  final double? _value;

  double get accuracy {
    if (_value != null) return _value;
    return type.accuracy;
  }
}

class FilterConfig {
  const FilterConfig({this.rules = const []});

  static const FilterConfig none = FilterConfig();

  static const FilterConfig safeOnly = FilterConfig(
    rules: [
      FilterRule(type: FilterType.nudity),
      FilterRule(type: FilterType.violence),
      FilterRule(type: FilterType.graphic),
      FilterRule(type: FilterType.duplicate),
    ],
  );

  static const FilterConfig safeAndClean = FilterConfig(
    rules: [
      FilterRule(type: FilterType.nudity),
      FilterRule(type: FilterType.violence),
      FilterRule(type: FilterType.graphic),
      FilterRule(type: FilterType.blur),
      FilterRule(type: FilterType.darkOrLowLight),
      FilterRule(type: FilterType.screenshot),
      FilterRule(type: FilterType.selfie),
      FilterRule(type: FilterType.duplicate),
    ],
  );

  final List<FilterRule> rules;

  bool get hasRules => rules.isNotEmpty;

  bool get hasEagerRules => rules.any((r) => !r.lazy);

  bool get hasLazyRules => rules.any((r) => r.lazy);

  List<FilterRule> get eagerRules => rules.where((r) => !r.lazy).toList();

  List<FilterRule> get lazyRules => rules.where((r) => r.lazy).toList();

  FilterRule? ruleFor(FilterType type) {
    try {
      return rules.firstWhere((r) => r.type == type);
    } catch (_) {
      return null;
    }
  }
}

abstract class FilterChecker {
  FilterType get type;

  Future<bool> matches(Uint8List thumbnail, double accuracy);

  Future<void> dispose();
}

abstract class Filter {
  final Map<FilterType, FilterChecker> checkers;

  const Filter(this.checkers);

  Future<bool> detectFromBytes(
    Uint8List thumbnail,
    FilterType type, {
    double? accuracy,
  }) async {
    final checker = checkers[type];
    if (checker == null) return false;
    final matched = await checker.matches(thumbnail, accuracy ?? type.accuracy);
    return matched;
  }

  Future<List<bool>> detectAllFromBytes(
    List<Uint8List> thumbnails,
    FilterType type, {
    double? accuracy,
  }) async {
    final checker = checkers[type];
    if (checker == null) return thumbnails.map((e) => false).toList();
    final futures = thumbnails.map((e) {
      return detectFromBytes(e, type, accuracy: accuracy);
    });
    return Future.wait(futures);
  }

  Future<bool> shouldInclude(Uint8List thumbnail, FilterConfig config) async {
    if (!config.hasRules) return true;
    for (final rule in config.rules) {
      final checker = checkers[rule.type];
      if (checker == null) continue;
      final matched = await checker.matches(thumbnail, rule.accuracy);
      if (rule.allow ? !matched : matched) return false;
    }
    return true;
  }

  Future<FilterType> firstMatchedType(
    Uint8List thumbnail,
    List<FilterRule> rules,
  ) async {
    for (final rule in rules) {
      final checker = checkers[rule.type];
      if (checker == null) continue;
      final matched = await checker.matches(thumbnail, rule.accuracy);
      if (matched) return rule.type;
    }
    return FilterType.none;
  }

  Future<List<FilterType>> matchedTypes(
    Uint8List thumbnail,
    Map<FilterType, double?> filters,
  ) async {
    Set<FilterType> match = {};
    for (final filter in filters.entries) {
      final checker = checkers[filter.key];
      if (checker == null) continue;
      final matched = await checker.matches(
        thumbnail,
        filter.value ?? filter.key.accuracy,
      );
      if (matched) {
        match.add(filter.key);
      }
    }
    return match.toList();
  }

  void resetSession() {}

  Future<void> dispose();
}
