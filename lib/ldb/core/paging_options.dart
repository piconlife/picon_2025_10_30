class InAppPagingOptions {
  final bool fetchFromLast;
  final int? fetchingSize;
  final int? initialSize;

  const InAppPagingOptions({
    int? initialFetchSize,
    this.fetchFromLast = false,
    this.fetchingSize,
  }) : initialSize = initialFetchSize ?? fetchingSize;

  InAppPagingOptions copy({
    bool? fetchFromLast,
    int? fetchingSize,
    int? initialSize,
  }) {
    return InAppPagingOptions(
      initialFetchSize: initialSize ?? this.initialSize,
      fetchingSize: fetchingSize ?? this.fetchingSize,
      fetchFromLast: fetchFromLast ?? this.fetchFromLast,
    );
  }

  bool get hasLimit => (fetchingSize ?? 0) > 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InAppPagingOptions &&
          other.fetchFromLast == fetchFromLast &&
          other.fetchingSize == fetchingSize &&
          other.initialSize == initialSize;

  @override
  int get hashCode => Object.hash(fetchFromLast, fetchingSize, initialSize);

  @override
  String toString() =>
      'InAppPagingOptions(fetchFromLast: $fetchFromLast, fetchingSize: $fetchingSize, initialSize: $initialSize)';
}
