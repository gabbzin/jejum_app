import 'package:jejum_app/domain/repositories/fasting_session_repository.dart';

class CancelSessionUseCase {
  final FastingSessionRepository _repository;

  CancelSessionUseCase(this._repository);

  Future<void> call() async {
    final actualSession = await _repository.getActual();

    if (actualSession == null) {
      throw Exception('Não há uma sessão de jejum em andamento.');
    }

    return _repository.cancel(actualSession.id);
  }
}
