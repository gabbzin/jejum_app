import 'package:jejum_app/domain/entities/fasting_session.dart';
import 'package:jejum_app/domain/repositories/fasting_session_repository.dart';

class EndFastingSessionUseCase {
  final FastingSessionRepository _repository;

  EndFastingSessionUseCase(this._repository);

  Future<void> call() async {
    final session = await _repository.getActual();

    if (session == null) {
      throw Exception('Sessão de jejum não encontrada');
    }

    if (session.status != FastingStatus.active &&
        session.status != FastingStatus.paused) {
      throw Exception(
        'Não há uma sessão de jejum ativa ou pausada para encerrar',
      );
    }

    final updatedSession = session.copyWith(
      endTime: DateTime.now(),
      pausedAt: null,
      status: FastingStatus.finished,
    );

    await _repository.save(updatedSession);
  }
}
