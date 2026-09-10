import 'package:jejum_app/domain/repositories/protocol_repository.dart';

class DeleteCustomProtocolUseCase {
  final ProtocolRepository _protocolRepository;

  DeleteCustomProtocolUseCase(this._protocolRepository);

  Future<void> call(String protocolId) {
    return _protocolRepository.delete(protocolId);
  }
}
