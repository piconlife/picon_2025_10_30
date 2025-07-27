part of 'view.dart';

enum LoadingState {
  loading,
  loaded,
  failed,
  nullable;

  bool get isLoading => this == LoadingState.loading;

  bool get isLoaded => this == LoadingState.loaded;

  bool get isFailed => this == LoadingState.failed;

  bool get isNullable => this == LoadingState.nullable;

  factory LoadingState.from(AsyncSnapshot snapshot) {
    var state = snapshot.connectionState;
    if (state == ConnectionState.waiting) {
      return LoadingState.loading;
    } else {
      var data = snapshot.data;
      if (data is List && data.isEmpty) {
        return LoadingState.nullable;
      } else if (data is Map && data.isEmpty) {
        return LoadingState.nullable;
      } else if (data == null) {
        return LoadingState.nullable;
      } else {
        return LoadingState.loaded;
      }
    }
  }
}
