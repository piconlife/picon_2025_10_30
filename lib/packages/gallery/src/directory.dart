import 'package:photo_manager/photo_manager.dart' show AssetPathEntity;

class GalleryDirectory {
  const GalleryDirectory(this.entity);

  final AssetPathEntity entity;

  String get id => entity.id;

  String get name => entity.name;

  @override
  int get hashCode => entity.hashCode;

  @override
  bool operator ==(Object other) =>
      other is GalleryDirectory && entity == other.entity;

  @override
  String toString() => 'GalleryDirectory(id: $id, name: $name)';
}
