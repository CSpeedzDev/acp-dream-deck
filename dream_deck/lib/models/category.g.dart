// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DreamCategoryModelAdapter extends TypeAdapter<DreamCategoryModel> {
  @override
  final int typeId = 1;

  @override
  DreamCategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DreamCategoryModel(
      id: fields[0] as String,
      title: fields[1] as String,
      emoji: fields[2] as String,
      colorValue: fields[3] as int,
      isDefault: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DreamCategoryModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.emoji)
      ..writeByte(3)
      ..write(obj.colorValue)
      ..writeByte(4)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DreamCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
