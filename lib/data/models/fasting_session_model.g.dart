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
      pausedAt: fields[5] as DateTime?,
      totalPausedDuration: fields[6] as int,
      targetDuration: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FastingSessionModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.protocolId)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.pausedAt)
      ..writeByte(6)
      ..write(obj.totalPausedDuration)
      ..writeByte(7)
      ..write(obj.targetDuration);
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
