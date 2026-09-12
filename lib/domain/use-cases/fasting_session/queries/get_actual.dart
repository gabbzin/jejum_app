import 'package:jejum_app/domain/entities/fasting_session.dart';
import 'package:jejum_app/domain/repositories/fasting_session_repository.dart';

class GetActualFastingSessionUseCase {
  final FastingSessionRepository _repository;

  GetActualFastingSessionUseCase(this._repository);

  Future<FastingSession?> call() {
    return _repository.getActual();
  }
}
