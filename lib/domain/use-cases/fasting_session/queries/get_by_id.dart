import 'package:jejum_app/domain/repositories/fasting_session_repository.dart';
import 'package:jejum_app/domain/entities/fasting_session.dart';

class GetByIdFastingSessionsUseCase {
  final FastingSessionRepository _repository;

  GetByIdFastingSessionsUseCase(this._repository);

  Future<FastingSession?> call(String id) {
    return _repository.getById(id);
  }
}
