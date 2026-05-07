class DataFieldReplacer {
  const DataFieldReplacer._();

  static String replace(String path, Map<String, String> params) {
    return path.replaceAllMapped(RegExp(r'{(\w+)}'), (match) {
      String key = match.group(1)!;
      return params.containsKey(key) ? params[key]! : match.group(0)!;
    });
  }

  static String replaceByIterable(String path, Iterable<String> params) {
    int i = 0;
    return path.replaceAllMapped(RegExp(r'{(\w+)}'), (match) {
      return i < params.length ? params.elementAt(i++) : match.group(0)!;
    });
  }
}
