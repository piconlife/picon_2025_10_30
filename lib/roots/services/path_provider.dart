class PathProvider {
  const PathProvider._();

  static String generatePath(String path, String id, [String? parentPath]) {
    if (parentPath != null && parentPath.isNotEmpty) {
      return "$parentPath/$path/$id";
    } else {
      return "$path/$id";
    }
  }

  static String generatePlaceholder(
    String path,
    String placeholder, [
    String? parentPath,
  ]) {
    if (parentPath != null && parentPath.isNotEmpty) {
      return "$parentPath/$path/{$placeholder}";
    } else {
      return "$path/{$placeholder}";
    }
  }
}
