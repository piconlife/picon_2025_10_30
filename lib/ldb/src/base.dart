part of 'database.dart';

typedef InAppValue = Object?;
typedef InAppDocument = Map<String, InAppValue>;

class InAppSetOptions {
  final bool merge;

  const InAppSetOptions({this.merge = false});

  static const InAppSetOptions defaults = InAppSetOptions();
  static const InAppSetOptions mergeAll = InAppSetOptions(merge: true);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InAppSetOptions && other.merge == merge;

  @override
  int get hashCode => merge.hashCode;
}

enum InAppReadType {
  collection,
  document;

  bool get isCollection => this == collection;

  bool get isDocument => this == document;
}

enum InAppWriteType {
  collection,
  document;

  bool get isCollection => this == collection;

  bool get isDocument => this == document;
}

class InAppWriteLimitation {
  final int limit;
  final bool limitByRecent;

  const InAppWriteLimitation(this.limit, {this.limitByRecent = true});

  bool get isUnlimited => limit <= 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InAppWriteLimitation &&
          other.limit == limit &&
          other.limitByRecent == limitByRecent;

  @override
  int get hashCode => Object.hash(limit, limitByRecent);
}

class InAppDatabaseException implements Exception {
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  const InAppDatabaseException(this.message, {this.cause, this.stackTrace});

  @override
  String toString() {
    final base = 'InAppDatabaseException: $message';
    return cause == null ? base : '$base (cause: $cause)';
  }
}
