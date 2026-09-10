import 'package:jejum_app/data/models/fasting_session_model.dart';
import 'package:jejum_app/domain/entities/fasting_session.dart';

class FastingSessionMapper {
  static FastingSession toEntity(FastingSessionModel model) {
    return FastingSession(
      id: model.id,
      protocolId: model.protocolId,
      startTime: model.startTime,
      endTime: model.endTime,
      status: model.status,
    );
  }

  static FastingSessionModel toModel(FastingSession entity) {
    return FastingSessionModel(
      id: entity.id,
      protocolId: entity.protocolId,
      startTime: entity.startTime,
      endTime: entity.endTime,
      status: entity.status,
    );
  }
}
