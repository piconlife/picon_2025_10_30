extension StringExtension on String {
  String get asPath => replaceAll(" ", "_")
      .replaceAll("/", "_")
      .replaceAll("-", "_")
      .replaceAll("'", "")
      .replaceAll('"', "");
}
