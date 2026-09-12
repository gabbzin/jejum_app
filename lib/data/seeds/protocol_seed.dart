import 'package:jejum_app/domain/entities/protocol.dart';
import 'package:jejum_app/domain/repositories/protocol_repository.dart';

class ProtocolSeed {
  static Future<void> seed(ProtocolRepository repository) async {
    for (final protocol in Protocol.predefined) {
      final existingProtocol = await repository.getById(protocol.id);
      if (existingProtocol == null) {
        await repository.save(protocol);
      }
    }
  }
}
