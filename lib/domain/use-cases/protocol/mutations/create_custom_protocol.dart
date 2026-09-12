import 'package:jejum_app/domain/repositories/protocol_repository.dart';
import 'package:jejum_app/domain/entities/protocol.dart';
import 'package:uuid/uuid.dart';

class CreateCustomProtocolUseCase {
  final ProtocolRepository _protocolRepository;

  CreateCustomProtocolUseCase(this._protocolRepository);

  Future<void> call({
    required String name,
    required int fastingHours,
    required int eatingHours,
  }) async {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      throw ArgumentError('O nome do protocolo não pode ser vazio.');
    }

    if (fastingHours <= 0 || eatingHours <= 0) {
      throw ArgumentError(
        'Horas de jejum e alimentação devem ser maiores que zero.',
      );
    }

    if (fastingHours + eatingHours != 24) {
      throw ArgumentError(
        'A soma das horas de jejum e alimentação deve ser igual a 24.',
      );
    }

    final existingProtocol = await _protocolRepository.getByName(trimmedName);

    if (existingProtocol != null) {
      throw ArgumentError('Já existe um protocolo com esse nome.');
    }

    if (Protocol.predefined.any(
      (protocol) =>
          protocol.fastingHours == fastingHours &&
          protocol.eatingHours == eatingHours,
    )) {
      throw ArgumentError(
        'Já existe um protocolo pré-definido com essas horas de jejum e alimentação.',
      );
    }

    final protocol = Protocol(
      id: const Uuid().v4(),
      name: trimmedName,
      fastingHours: fastingHours,
      eatingHours: eatingHours,
      isCustom: true,
    );
    return _protocolRepository.save(protocol);
  }
}
