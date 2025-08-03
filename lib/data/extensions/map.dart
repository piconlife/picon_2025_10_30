extension MapEx on Map<String, dynamic> {
  bool isInsertable(String key, value) {
    return value != null;
  }

  Map<String, dynamic> set(String key, value, [bool nullable = false]) {
    if (nullable || isInsertable(key, value)) {
      return this..putIfAbsent(key, () => value);
    } else {
      return this;
    }
  }

  T? get<T>(String key) {
    final i = this[key];
    if (i is T) {
      return i;
    } else {
      return null;
    }
  }
}
