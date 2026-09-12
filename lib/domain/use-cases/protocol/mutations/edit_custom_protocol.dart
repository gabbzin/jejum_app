import 'package:jejum_app/domain/entities/protocol.dart';
import 'package:jejum_app/domain/repositories/protocol_repository.dart';

class EditCustomProtocolUseCase {
  final ProtocolRepository _protocolRepository;

  EditCustomProtocolUseCase(this._protocolRepository);

  Future<void> call({
    required String protocolId,
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

    final existing = await _protocolRepository.getById(protocolId);
    if (existing == null) {
      throw ArgumentError('Protocolo não encontrado.');
    }

    if (!existing.isCustom) {
      throw ArgumentError('Apenas protocolos customizados podem ser editados.');
    }

    // Verifica duplicata de nome (case-insensitive, ignorando o próprio protocolo)
    final all = await _protocolRepository.getAll();
    final duplicateName = all.any(
      (p) =>
          p.id != protocolId &&
          p.name.trim().toLowerCase() == trimmedName.toLowerCase(),
    );
    if (duplicateName) {
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

    final updated = Protocol(
      id: protocolId,
      name: trimmedName,
      fastingHours: fastingHours,
      eatingHours: eatingHours,
      isCustom: true,
    );

    return _protocolRepository.save(updated);
  }
}
