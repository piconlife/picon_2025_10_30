// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FollowActionAdapter extends TypeAdapter<FollowAction> {
  @override
  final int typeId = 21;

  @override
  FollowAction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FollowAction(
      otherUid: fields[0] as String,
      type: FollowActionType.values[fields[1] as int],
      createdAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FollowAction obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.otherUid)
      ..writeByte(1)
      ..write(obj.typeIndex)
      ..writeByte(2)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FollowActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
