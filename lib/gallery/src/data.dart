import 'dart:io' show File;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:photo_manager/photo_manager.dart' show AssetEntity;

import 'enums.dart' show AssetType;
import 'filter.dart' show FilterType;

class GalleryData {
  const GalleryData(
    this.entity, {
    this.filters = const [],
    this.pendingFilters = const [],
    this.blurredFilterTypes = const [],
  });

  final AssetEntity entity;
  final List<FilterType> filters;
  final List<FilterType> pendingFilters;
  final List<FilterType> blurredFilterTypes;

  String get id => entity.id;

  AssetType get type => switch (entity.type.name) {
    'audio' => AssetType.audio,
    'image' => AssetType.image,
    'video' => AssetType.video,
    _ => AssetType.other,
  };

  Duration get videoDuration => entity.videoDuration;

  Future<File?> get file => entity.file;

  bool get isFiltering => pendingFilters.isNotEmpty;

  bool get isFiltered => !isFiltering && filters.isNotEmpty;

  bool get isBlurred => blurredFilterTypes.isNotEmpty;

  GalleryData withLazyResolved({FilterType? matchedType, bool blur = false}) {
    return GalleryData(
      entity,
      filters:
          matchedType != null && !filters.contains(matchedType)
              ? [...filters, matchedType]
              : List<FilterType>.from(filters),
      pendingFilters: const [],
      blurredFilterTypes:
          blur &&
                  matchedType != null &&
                  !blurredFilterTypes.contains(matchedType)
              ? [...blurredFilterTypes, matchedType]
              : List<FilterType>.from(blurredFilterTypes),
    );
  }

  GalleryData copyWith({
    List<FilterType>? filters,
    List<FilterType>? pendingFilters,
    List<FilterType>? blurredFilterTypes,
  }) => GalleryData(
    entity,
    filters: filters ?? this.filters,
    pendingFilters: pendingFilters ?? this.pendingFilters,
    blurredFilterTypes: blurredFilterTypes ?? this.blurredFilterTypes,
  );

  @override
  int get hashCode =>
      Object.hash(entity, filters, pendingFilters, blurredFilterTypes);

  @override
  bool operator ==(Object other) =>
      other is GalleryData &&
      entity == other.entity &&
      listEquals(filters, other.filters) &&
      listEquals(pendingFilters, other.pendingFilters) &&
      listEquals(blurredFilterTypes, other.blurredFilterTypes);

  @override
  String toString() =>
      'GalleryData(id: $id, filters: $filters, pending: $pendingFilters, blurred: $blurredFilterTypes)';
}
