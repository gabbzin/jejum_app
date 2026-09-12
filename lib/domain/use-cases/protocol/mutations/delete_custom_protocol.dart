import 'package:jejum_app/domain/repositories/protocol_repository.dart';

class DeleteCustomProtocolUseCase {
  final ProtocolRepository _protocolRepository;

  DeleteCustomProtocolUseCase(this._protocolRepository);

  Future<void> call(String protocolId) async {
    final protocol = await _protocolRepository.getById(protocolId);
    if (protocol == null) {
      throw ArgumentError('Protocolo não encontrado.');
    }
    if (!protocol.isCustom) {
      throw ArgumentError('Apenas protocolos customizados podem ser removidos.');
    }
    return _protocolRepository.delete(protocolId);
  }
}
