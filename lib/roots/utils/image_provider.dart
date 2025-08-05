import 'package:flutter/foundation.dart';
import 'package:flutter_andomie/utils/key_generator.dart';

import '../../app/utils/media_picker.dart';
import '../../data/models/photo.dart';
import '../contents/media.dart';

enum EditablePhotoProviderStatus {
  initial,
  loading,
  done;

  bool get isLoading => this == loading;
}

class EditablePhotoProvider extends ChangeNotifier {
  EditablePhotoProviderStatus status = EditablePhotoProviderStatus.initial;
  List<EditablePhoto> photos = [];
  List<EditablePhoto> removes = [];

  EditablePhotoProvider([
    List<EditablePhoto>? value,
    bool initialChoosingModeWhenEmpty = true,
  ]) {
    if (value != null) photos = value;
    if (initialChoosingModeWhenEmpty && photos.isEmpty) choose();
  }

  void notify([VoidCallback? callback]) {
    if (callback != null) callback();
    notifyListeners();
  }

  void choose() async {
    notify(() => status = EditablePhotoProviderStatus.loading);
    final feedback = await MediaPicker.I.chooseImages();
    if (feedback.isNotEmpty) {
      final items = feedback.map(EditablePhoto.data);
      photos.insertAll(0, items);
    }
    notify(() => status = EditablePhotoProviderStatus.done);
  }

  void crop(int index) async {
    final item = photos[index];
    final data = item.rootData;
    if (item.editable && data is MediaData) {
      notify(() => status = EditablePhotoProviderStatus.loading);
      final feedback = await MediaPicker.I.cropImage(path: data.path ?? "");
      if (feedback != null) {
        final current = photos.removeAt(index);
        photos.insert(index, current.copy(feedback));
      }
      notify(() => status = EditablePhotoProviderStatus.done);
    }
  }

  void remove(int index) {
    notify(() => removes.add(photos.removeAt(index)));
  }

  @override
  void dispose() {
    photos.clear();
    removes.clear();
    super.dispose();
  }
}

class EditablePhoto {
  final String id;
  final bool editable;
  final Object? _data;

  Object? get data => _data is MediaData
      ? (_data).data
      : _data is Photo
      ? (_data).photoUrl
      : _data is String
      ? _data
      : null;

  Object? get rootData => _data;

  bool get isMediaData => rootData is MediaData;

  const EditablePhoto._({Object? data, required this.id})
    : _data = data,
      editable = !kIsWeb && data is MediaData;

  EditablePhoto.data(MediaData data)
    : this._(data: data, id: KeyGenerator.uniqueKey);

  EditablePhoto.photo(Photo photo) : this._(data: photo, id: photo.id);

  EditablePhoto copy([Object? data]) {
    return EditablePhoto._(id: id, data: data ?? this.data);
  }

  @override
  int get hashCode => id.hashCode ^ editable.hashCode ^ _data.hashCode;

  @override
  bool operator ==(Object other) {
    return other is EditablePhoto &&
        other.id == id &&
        other.editable == editable &&
        other._data == _data;
  }

  @override
  String toString() {
    return "$EditablePhoto#$hashCode(id: $id, editable: $editable, data: $_data)";
  }
}

class EditablePhotoFeedback {
  final List<EditablePhoto> currents;
  final List<EditablePhoto> deletes;

  bool get isEmpty => currents.isEmpty && deletes.isEmpty;

  const EditablePhotoFeedback({required this.currents, required this.deletes});
}
