import 'package:jejum_app/domain/entities/fasting_session.dart';
import 'package:jejum_app/domain/repositories/fasting_session_repository.dart';

class StartSessionUseCase {
  final FastingSessionRepository _repository;

  StartSessionUseCase(this._repository);

  // Criação
  Future<void> call(FastingSession session) async {
    final actualSession = await _repository.getActual();

    if (actualSession != null) {
      throw Exception(
        'Já existe uma sessão de jejum em andamento. Finalize a sessão atual antes de iniciar uma nova.',
      );
    }

    return _repository.save(session);
  }
}
