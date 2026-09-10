// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fasting_session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FastingSessionModelAdapter extends TypeAdapter<FastingSessionModel> {
  @override
  final int typeId = 1;

  @override
  FastingSessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FastingSessionModel(
      id: fields[0] as String,
      protocolId: fields[1] as String,
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime?,
      status: fields[4] as FastingStatus,
    );
  }

  @override
  void write(BinaryWriter writer, FastingSessionModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.protocolId)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FastingSessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
