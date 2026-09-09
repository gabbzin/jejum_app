import 'package:jejum_app/data/models/protocol_model.dart';
import 'package:jejum_app/domain/entities/protocol.dart';

class ProtocolMapper {
  static Protocol toEntity(ProtocolModel model) {
    return Protocol(
      id: model.id,
      name: model.name,
      eatingHours: model.eatingHours,
      fastingHours: model.fastingHours,
      isCustom: model.isCustom,
    );
  }

  static ProtocolModel toModel(Protocol entity) {
    return ProtocolModel(
      id: entity.id,
      name: entity.name,
      eatingHours: entity.eatingHours,
      fastingHours: entity.fastingHours,
      isCustom: entity.isCustom,
    );
  }
}
