import 'package:jejum_app/domain/entities/fasting_session.dart';
import 'package:jejum_app/domain/repositories/fasting_session_repository.dart';

class PauseFastingSessionUseCase {
  final FastingSessionRepository _repository;

  PauseFastingSessionUseCase(this._repository);

  Future<void> call() async {
    final session = await _repository.getActual();
    if (session == null) {
      throw Exception('Sessão de jejum não encontrada');
    }

    if (session.status != FastingStatus.active) {
      throw Exception('Não é possível pausar uma sessão que não está ativa');
    }

    final updatedSession = session.copyWith(
      status: FastingStatus.paused,
      pausedAt: DateTime.now(),
    );
    await _repository.save(updatedSession);
  }
}
