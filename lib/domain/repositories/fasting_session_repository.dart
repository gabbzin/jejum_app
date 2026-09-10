import 'package:jejum_app/domain/entities/fasting_session.dart';

abstract class FastingSessionRepository {
  Future<List<FastingSession>> getAll();

  Future<FastingSession?> getById(String id);

  Future<FastingSession?> getByProtocolId(String protocolId);

  Future<FastingSession?> getActual();

  // Método para salvar (edição ou criação) de uma sessão de jejum
  Future<void> save(FastingSession fastingSession);

  Future<void> delete(String id);
}
