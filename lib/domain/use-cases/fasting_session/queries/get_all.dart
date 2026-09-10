import 'package:jejum_app/domain/entities/fasting_session.dart';
import 'package:jejum_app/domain/repositories/fasting_session_repository.dart';

class GetAllFastingSessionsUseCase {
  final FastingSessionRepository _repository;

  GetAllFastingSessionsUseCase(this._repository);

  Future<List<FastingSession>> call() {
    return _repository.getAll();
  }
}
