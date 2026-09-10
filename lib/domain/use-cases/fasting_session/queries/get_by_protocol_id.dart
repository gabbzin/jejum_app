import 'package:jejum_app/data/repositories/fasting_session_repository_impl.dart';
import 'package:jejum_app/domain/entities/fasting_session.dart';

class GetByProtocolIdFastingSessionsUseCase {
  final FastingSessionRepositoryImpl _repository;

  GetByProtocolIdFastingSessionsUseCase(this._repository);

  Future<List<FastingSession?>> call(String protocolId) {
    return _repository.getByProtocolId(protocolId);
  }
}
