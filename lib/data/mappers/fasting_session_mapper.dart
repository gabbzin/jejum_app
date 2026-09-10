import 'package:jejum_app/data/models/fasting_session_model.dart';
import 'package:jejum_app/domain/entities/fasting_session.dart';

class FastingSessionMapper {
  static FastingSession toEntity(FastingSessionModel model) {
    return FastingSession(
      id: model.id,
      protocolId: model.protocolId,
      startTime: model.startTime,
      endTime: model.endTime,
      pausedAt: model.pausedAt,
      totalPausedDuration: Duration(milliseconds: model.totalPausedDuration),
      status: model.status,
      targetDuration: Duration(milliseconds: model.targetDuration),
    );
  }

  static FastingSessionModel toModel(FastingSession entity) {
    return FastingSessionModel(
      id: entity.id,
      protocolId: entity.protocolId,
      startTime: entity.startTime,
      endTime: entity.endTime,
      status: entity.status,
      pausedAt: entity.pausedAt,
      totalPausedDuration:
          entity.totalPausedDuration!.inMilliseconds, // Possivel troca
      targetDuration: entity.targetDuration.inMilliseconds,
    );
  }
}
