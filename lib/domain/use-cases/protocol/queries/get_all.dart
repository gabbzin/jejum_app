import 'package:jejum_app/domain/entities/protocol.dart';
import 'package:jejum_app/domain/repositories/protocol_repository.dart';

class GetAllProtocolUseCase {
  final ProtocolRepository _protocolRepository;

  GetAllProtocolUseCase(this._protocolRepository);

  Future<List<Protocol>> call() async {
    return _protocolRepository.getAll();
  }
}
