// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HivePreferencesModelAdapter extends TypeAdapter<HivePreferencesModel> {
  @override
  final int typeId = 69;

  @override
  HivePreferencesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePreferencesModel()
      ..anyBool = fields[0] as bool?
      ..anyInt = fields[1] as int?
      ..anyDouble = fields[2] as double?
      ..anyString = fields[3] as String?;
  }

  @override
  void write(BinaryWriter writer, HivePreferencesModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.anyBool)
      ..writeByte(1)
      ..write(obj.anyInt)
      ..writeByte(2)
      ..write(obj.anyDouble)
      ..writeByte(3)
      ..write(obj.anyString);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HivePreferencesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
