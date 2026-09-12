import 'package:hive/hive.dart';
import 'package:jejum_app/domain/entities/fasting_session.dart';

class FastingStatusAdapter extends TypeAdapter<FastingStatus> {
  @override
  final int typeId = 3;

  @override
  FastingStatus read(BinaryReader reader) {
    return FastingStatus.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, FastingStatus status) {
    writer.writeByte(status.index);
  }
}
