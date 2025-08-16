extension StringExtension on String {
  String get asKey => trim()
      .toLowerCase()
      .replaceAll(" ", "_")
      .replaceAll("/", "_")
      .replaceAll("-", "")
      .replaceAll(".", "_")
      .replaceAll(",", "_")
      .replaceAll("'", "")
      .replaceAll('"', "");
}
