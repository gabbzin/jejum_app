import 'package:hive/hive.dart';

part 'fasting_session_model.g.dart';

@HiveType(typeId: 1)
class FastingSessionModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String protocolId;

  @HiveField(2)
  DateTime startTime;

  @HiveField(3)
  DateTime endTime;

  FastingSessionModel({
    required this.id,
    required this.protocolId,
    required this.startTime,
    required this.endTime,
  });
}
