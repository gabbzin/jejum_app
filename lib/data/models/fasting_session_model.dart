import 'package:hive/hive.dart';
import 'package:jejum_app/domain/entities/fasting_session.dart';

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
  DateTime? endTime;

  @HiveField(4)
  FastingStatus status;

  FastingSessionModel({
    required this.id,
    required this.protocolId,
    required this.startTime,
    this.endTime,
    required this.status,
  });
}
