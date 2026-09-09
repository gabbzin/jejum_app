// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocol_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProtocolModelAdapter extends TypeAdapter<ProtocolModel> {
  @override
  final int typeId = 0;

  @override
  ProtocolModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProtocolModel(
      id: fields[0] as String,
      name: fields[1] as String,
      fastingHours: fields[2] as int,
      eatingHours: fields[3] as int,
      isCustom: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProtocolModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.fastingHours)
      ..writeByte(3)
      ..write(obj.eatingHours)
      ..writeByte(4)
      ..write(obj.isCustom);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtocolModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
