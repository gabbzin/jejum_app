import 'package:jejum_app/domain/entities/fasting_session.dart';
import 'package:jejum_app/domain/repositories/fasting_session_repository.dart';
import 'package:jejum_app/domain/repositories/protocol_repository.dart';
import 'package:uuid/v4.dart';

class StartSessionUseCase {
  final FastingSessionRepository _repository;
  final ProtocolRepository _protocolRepository;

  StartSessionUseCase(this._repository, this._protocolRepository);

  // Criação
  Future<void> call({required String protocolId}) async {
    final actualSession = await _repository.getActual();

    if (actualSession != null) {
      throw Exception(
        'Já existe uma sessão de jejum em andamento. Finalize a sessão atual antes de iniciar uma nova.',
      );
    }

    final protocol = await _protocolRepository.getById(protocolId);

    final session = FastingSession(
      id: const UuidV4().toString(),
      protocolId: protocolId,
      startTime: DateTime.now(),
      targetDuration: Duration(hours: protocol?.fastingHours ?? 0),
      status: FastingStatus.active,
      
    );

    return _repository.save(session);
  }
}
