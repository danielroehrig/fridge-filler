// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListEntryAdapter extends TypeAdapter<ListEntry> {
  @override
  final int typeId = 1;

  @override
  ListEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListEntry(
      name: fields[1] as String,
      position: fields[3] as int?,
    )
      ..id = fields[0] as String
      ..entries = (fields[2] as List).cast<ItemEntry>()
      ..description = fields[4] as String?;
  }

  @override
  void write(BinaryWriter writer, ListEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.position)
      ..writeByte(2)
      ..write(obj.entries)
      ..writeByte(4)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ItemEntryAdapter extends TypeAdapter<ItemEntry> {
  @override
  final int typeId = 2;

  @override
  ItemEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemEntry(
      name: fields[0] as String,
      amount: fields[1] as String?,
    )
      ..id = fields[2] as String
      ..position = fields[3] as int?
      ..description = fields[4] as String?
      ..done = fields[5] == null ? false : fields[5] as bool;
  }

  @override
  void write(BinaryWriter writer, ItemEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.position)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.done);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
