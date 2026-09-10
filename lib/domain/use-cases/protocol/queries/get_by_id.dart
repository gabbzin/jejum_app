import 'package:jejum_app/domain/entities/protocol.dart';
import 'package:jejum_app/domain/repositories/protocol_repository.dart';

class GetProtocolByIdUseCase {
  final ProtocolRepository _protocolRepository;

  GetProtocolByIdUseCase(this._protocolRepository);

  Future<Protocol?> call(String id) async {
    return _protocolRepository.getById(id);
  }
}
