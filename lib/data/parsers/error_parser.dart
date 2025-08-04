String parseError(Object? error) {
  String exception = error.toString();
  if (exception.contains("[cloud_firestore/unavailable]")) {
    exception = exception.replaceAll("[cloud_firestore/unavailable]", "");
  }
  if (exception.contains("[cloud_firestore/not-found]")) {
    exception = exception.replaceAll("[cloud_firestore/not-found]", "");
  }
  return exception.trim();
}
