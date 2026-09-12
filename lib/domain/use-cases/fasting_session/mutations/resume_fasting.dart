import 'package:jejum_app/domain/entities/fasting_session.dart';
import 'package:jejum_app/domain/repositories/fasting_session_repository.dart';

class ResumeFastingSessionUseCase {
  final FastingSessionRepository _repository;

  ResumeFastingSessionUseCase(this._repository);

  Future<void> call() async {
    final session = await _repository.getActual();
    if (session == null) {
      throw Exception('Sessão de jejum não encontrada');
    }

    if (session.status != FastingStatus.paused) {
      throw Exception('O status não está pausado');
    }

    final pausedAt = session.pausedAt;
    if (pausedAt == null) {
      throw Exception('Sessão pausada sem horário de pausa');
    }

    final updatedSession = session.copyWith(
      status: FastingStatus.active,
      pausedAt: null,
      totalPausedDuration:
          (session.totalPausedDuration ?? Duration.zero) +
          DateTime.now().difference(pausedAt),
    );
    await _repository.save(updatedSession);
  }
}
