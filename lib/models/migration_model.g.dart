// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'migration_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MigrationAdapter extends TypeAdapter<Migration> {
  @override
  final int typeId = 3;

  @override
  Migration read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Migration(
      id: fields[0] as int,
      applied: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Migration obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.applied);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MigrationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
