abstract class DataWriteBatch {
  bool _committed = false;
  int _operationCount = 0;

  int get operationCount => _operationCount;

  bool get isEmpty => _operationCount == 0;

  bool get isNotEmpty => _operationCount > 0;

  bool get isCommitted => _committed;

  void onDelete(String path);

  void onSet(String path, Object data, {bool merge = true});

  void onUpdate(String path, Map<String, dynamic> data);

  Future<void> onCommit();

  void delete(String path) {
    _ensureNotCommitted();
    onDelete(path);
    _operationCount++;
  }

  void set(String path, Object data, {bool merge = true}) {
    _ensureNotCommitted();
    final payload =
        data is Map<String, dynamic> ? Map<String, dynamic>.from(data) : data;
    onSet(path, payload, merge: merge);
    _operationCount++;
  }

  void update(String path, Map<String, dynamic> data) {
    _ensureNotCommitted();
    onUpdate(path, Map<String, dynamic>.from(data));
    _operationCount++;
  }

  Future<void> commit() async {
    _ensureNotCommitted();
    _committed = true;
    await onCommit();
  }

  void _ensureNotCommitted() {
    if (_committed) {
      throw StateError(
        'DataWriteBatch has already been committed and cannot be reused.',
      );
    }
  }
}
