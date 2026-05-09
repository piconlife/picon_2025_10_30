part of 'database.dart';

class InAppMerger {
  final InAppDocument root;

  InAppMerger(InAppDocument? root)
    : root = Map<String, InAppValue>.of(root ?? const {});

  InAppDocument merge(InAppDocument updates) {
    final extra = <String, InAppValue>{};
    for (final entry in updates.entries) {
      final field = entry.key;
      final fieldValue = entry.value;
      if (fieldValue is InAppFieldValue) {
        _apply(field, fieldValue, root[field]);
      } else {
        extra[field] = fieldValue;
      }
    }
    if (extra.isNotEmpty) root.addAll(extra);
    return root;
  }

  void _apply(String field, InAppFieldValue fieldValue, Object? baseValue) {
    final modifier = fieldValue.value;
    switch (fieldValue.type) {
      case InAppFieldValues.arrayFilter:
        _applyArrayFilter(field, baseValue, modifier);
        break;
      case InAppFieldValues.arrayRemove:
        _applyArrayRemove(field, baseValue, modifier);
        break;
      case InAppFieldValues.arrayUnify:
        _applyArrayUnify(field, baseValue);
        break;
      case InAppFieldValues.arrayUnion:
        _applyArrayUnion(field, baseValue, modifier);
        break;
      case InAppFieldValues.delete:
        _applyDelete(field);
        break;
      case InAppFieldValues.increment:
        _applyIncrement(field, baseValue, modifier);
        break;
      case InAppFieldValues.timestamp:
        _applyTimestamp(field, modifier);
        break;
      case InAppFieldValues.toggle:
        _applyToggle(field, baseValue, modifier);
        break;
      case InAppFieldValues.none:
        break;
    }
  }

  void _applyArrayFilter(String field, Object? base, Object? modifier) {
    if (base is List && modifier is bool Function(Object?)) {
      final merged = base.where(modifier).toList(growable: false);
      root[field] = merged.isEmpty ? null : merged;
    }
  }

  void _applyArrayRemove(String field, Object? base, Object? modifier) {
    if (base is List && modifier is List) {
      final removeSet = modifier.toSet();
      root[field] = base
          .where((e) => !removeSet.contains(e))
          .toList(growable: false);
    }
  }

  void _applyArrayUnify(String field, Object? base) {
    if (base is List) {
      final seen = <Object?>{};
      final merged = <Object?>[];
      for (final e in base) {
        if (seen.add(e)) merged.add(e);
      }
      root[field] = merged;
    }
  }

  void _applyArrayUnion(String field, Object? base, Object? modifier) {
    if ((base is List || base == null) && modifier is List) {
      final src = base is List ? base : const <Object?>[];
      final merged = <Object?>[...src, ...modifier];
      root[field] = merged;
    }
  }

  void _applyIncrement(String field, Object? base, Object? modifier) {
    if ((base is num || base == null) && modifier is num) {
      final current = base is num ? base : 0;
      root[field] = current + modifier;
    }
  }

  void _applyDelete(String field) {
    root.remove(field);
  }

  void _applyTimestamp(String field, Object? modifier) {
    final now = DateTime.now();
    final asNumber = modifier is bool ? modifier : false;
    root[field] = asNumber ? now.millisecondsSinceEpoch : now.toIso8601String();
  }

  void _applyToggle(String field, Object? base, Object? modifier) {
    final current = base is bool ? base : (modifier is bool ? modifier : false);
    root[field] = !current;
  }
}
