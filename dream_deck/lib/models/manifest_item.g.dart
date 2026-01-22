// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manifest_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ManifestItemAdapter extends TypeAdapter<ManifestItem> {
  @override
  final int typeId = 2;

  @override
  ManifestItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ManifestItem(
      id: fields[0] as String,
      dreamId: fields[1] as String,
      title: fields[2] as String,
      checklist: (fields[3] as List).cast<ChecklistItem>(),
      goalValues: (fields[4] as Map).cast<String, double>(),
      startedAt: fields[5] as DateTime,
      completedAt: fields[6] as DateTime?,
      isCompleted: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ManifestItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dreamId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.checklist)
      ..writeByte(4)
      ..write(obj.goalValues)
      ..writeByte(5)
      ..write(obj.startedAt)
      ..writeByte(6)
      ..write(obj.completedAt)
      ..writeByte(7)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ManifestItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChecklistItemAdapter extends TypeAdapter<ChecklistItem> {
  @override
  final int typeId = 3;

  @override
  ChecklistItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChecklistItem(
      title: fields[0] as String,
      isCompleted: fields[1] as bool,
      completedAt: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ChecklistItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.isCompleted)
      ..writeByte(2)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
