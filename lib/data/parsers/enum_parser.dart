extension EnumParser<T extends Enum> on Iterable<T> {
  T? tryParse(Object? source) {
    try {
      return firstWhere((e) {
        if (e == source) return true;
        if (e.index == source) return true;
        if (e.name.toLowerCase() == source.toString().toLowerCase()) {
          return true;
        }
        if (e.toString().toLowerCase() == source.toString().toLowerCase()) {
          return true;
        }
        return false;
      });
    } catch (e) {
      return null;
    }
  }

  T parse(Object? source, [T? fallback]) {
    return tryParse(source) ?? fallback ?? first;
  }
}
