import 'package:jejum_app/domain/repositories/fasting_session_repository.dart';

class DeleteFastingSessionUseCase {
  final FastingSessionRepository _repository;

  DeleteFastingSessionUseCase(this._repository);

  Future<void> call(String sessionId) async {
    await _repository.delete(sessionId);
  }
}
