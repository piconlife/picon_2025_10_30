class InAppPointer {
  InAppPointer(String path)
    : components =
          path.split('/').where((element) => element.isNotEmpty).toList();

  String get path => components.join('/');

  final List<String> components;

  String get id => components.last;

  bool isCollection() => components.length.isOdd;

  bool isDocument() => components.length.isEven;

  String collectionPath(String collectionPath) {
    assert(isDocument());
    return '$path/$collectionPath';
  }

  String documentPath(String documentPath) {
    assert(isCollection());
    return '$path/$documentPath';
  }

  String? parentPath() {
    if (components.length < 2) {
      return null;
    }

    List<String> parentComponents = List<String>.from(components)..removeLast();
    return parentComponents.join('/');
  }

  @override
  bool operator ==(Object other) => other is InAppPointer && other.path == path;

  @override
  int get hashCode => path.hashCode;
}
