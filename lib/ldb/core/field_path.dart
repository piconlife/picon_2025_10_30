enum InAppFieldPaths { documentId, none }

class InAppFieldPath {
  final Object? field;
  final InAppFieldPaths type;

  const InAppFieldPath(this.field, [this.type = InAppFieldPaths.none]);

  static const InAppFieldPath documentId = InAppFieldPath(
    null,
    InAppFieldPaths.documentId,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InAppFieldPath && other.field == field && other.type == type;

  @override
  int get hashCode => Object.hash(field, type);

  @override
  String toString() => 'InAppFieldPath(field: $field, type: $type)';
}
