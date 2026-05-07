import 'path_replacer.dart' show DataFieldReplacer;

abstract class DataFieldParams {
  const DataFieldParams();
}

class KeyParams extends DataFieldParams {
  final Map<String, String> values;

  const KeyParams(this.values);

  @override
  int get hashCode => values.hashCode;

  @override
  bool operator ==(Object other) {
    return other is KeyParams && other.values == values;
  }

  @override
  String toString() => "$KeyParams($values)";
}

class IterableParams extends DataFieldParams {
  final List<String> values;

  const IterableParams(this.values);

  @override
  int get hashCode => values.hashCode;

  @override
  bool operator ==(Object other) {
    return other is IterableParams && other.values == values;
  }

  @override
  String toString() => "$IterableParams($values)";
}

extension DataFieldParamsHelper on DataFieldParams? {
  String generate(String root) {
    final params = this;
    if (params is KeyParams) {
      return DataFieldReplacer.replace(root, params.values);
    } else if (params is IterableParams) {
      return DataFieldReplacer.replaceByIterable(root, params.values);
    } else {
      return root;
    }
  }
}
