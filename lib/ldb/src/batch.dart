import 'database.dart';

enum _BatchOperationType { set, update, delete }

class _BatchOperation {
  final _BatchOperationType type;
  final InAppDocumentReference document;
  final Map<String, dynamic>? data;
  final InAppSetOptions? options;

  _BatchOperation({
    required this.type,
    required this.document,
    this.data,
    this.options,
  });
}

class InAppWriteBatch {
  InAppWriteBatch();

  final List<_BatchOperation> _operations = [];

  void set(
    InAppDocumentReference document,
    Object data, [
    InAppSetOptions? options,
  ]) {
    if (data is! Map<String, dynamic>) return;
    _operations.add(
      _BatchOperation(
        type: _BatchOperationType.set,
        document: document,
        data: data,
        options: options,
      ),
    );
  }

  void update(InAppDocumentReference document, Map<String, dynamic> data) {
    _operations.add(
      _BatchOperation(
        type: _BatchOperationType.update,
        document: document,
        data: data,
      ),
    );
  }

  void delete(InAppDocumentReference document) {
    _operations.add(
      _BatchOperation(type: _BatchOperationType.delete, document: document),
    );
  }

  Future<void> commit() async {
    for (final op in _operations) {
      switch (op.type) {
        case _BatchOperationType.set:
          await op.document.set(op.data!, op.options!);
          break;
        case _BatchOperationType.update:
          await op.document.update(op.data!);
          break;
        case _BatchOperationType.delete:
          await op.document.delete();
          break;
      }
    }
    _operations.clear();
  }
}
