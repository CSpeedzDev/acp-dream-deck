// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dream.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DreamAdapter extends TypeAdapter<Dream> {
  @override
  final int typeId = 0;

  @override
  Dream read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dream(
      id: fields[0] as String,
      title: fields[1] as String,
      notes: fields[2] as String?,
      firstStep: fields[3] as String?,
      categoryIndex: fields[4] as int,
      isCompleted: fields[5] as bool,
      createdAt: fields[6] as DateTime,
      completedAt: fields[7] as DateTime?,
      snoozedUntil: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Dream obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.notes)
      ..writeByte(3)
      ..write(obj.firstStep)
      ..writeByte(4)
      ..write(obj.categoryIndex)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.completedAt)
      ..writeByte(8)
      ..write(obj.snoozedUntil);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DreamAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
