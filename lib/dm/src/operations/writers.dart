import 'package:collection/collection.dart' show MapEquality;

import '../utils/set_options.dart' show DataSetOptions;

const _e = MapEquality();

abstract class DataBatchWriter {
  final String path;

  const DataBatchWriter(this.path);

  @override
  int get hashCode => path.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is DataBatchWriter && other.path == path;
  }

  @override
  String toString() => '$DataBatchWriter#$hashCode{path: $path}';
}

class DataSetWriter extends DataBatchWriter {
  final Object data;
  final DataSetOptions options;

  const DataSetWriter(
    super.path,
    this.data, [
    this.options = const DataSetOptions(),
  ]);

  @override
  int get hashCode => Object.hash(path, data, options);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is! DataSetWriter) return false;
    if (other.path != path) return false;
    if (other.data != data) return false;
    if (other.options != options) return false;
    return true;
  }

  @override
  String toString() {
    return '$DataSetWriter#$hashCode{path: $path, data: $data, options: $options}';
  }
}

class DataUpdateWriter extends DataBatchWriter {
  final Map<String, dynamic> data;

  const DataUpdateWriter(super.path, this.data);

  @override
  int get hashCode => Object.hash(path, _e.hash(data));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DataUpdateWriter) return false;
    if (other.path != path) return false;
    return _e.equals(other.data, data);
  }

  @override
  String toString() {
    return '$DataUpdateWriter#$hashCode{path: $path, data: $data}';
  }
}

class DataDeleteWriter extends DataBatchWriter {
  const DataDeleteWriter(super.path);

  @override
  String toString() {
    return '$DataDeleteWriter#$hashCode{path: $path}';
  }
}
