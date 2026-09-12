import 'package:flutter_test/flutter_test.dart';
import 'package:jejum_app/data/seeds/protocol_seed.dart';
import 'package:jejum_app/domain/entities/protocol.dart';
import 'package:jejum_app/domain/repositories/protocol_repository.dart';

void main() {
  test('persists predefined protocols without duplicating them', () async {
    final repository = InMemoryProtocolRepository();
    final customProtocol = const Protocol(
      id: 'custom',
      name: 'Meu protocolo',
      fastingHours: 14,
      eatingHours: 10,
      isCustom: true,
    );
    await repository.save(customProtocol);

    await ProtocolSeed.seed(repository);
    await ProtocolSeed.seed(repository);

    expect(repository.protocols, hasLength(4));
    expect(repository.saveCalls, hasLength(4));
    expect(repository.protocols['custom'], customProtocol);
    expect(repository.protocols.keys, containsAll(['12_12', '16_8', '18_6']));
  });
}

class InMemoryProtocolRepository implements ProtocolRepository {
  final Map<String, Protocol> protocols = {};
  final List<Protocol> saveCalls = [];

  @override
  Future<void> delete(String id) async {
    protocols.remove(id);
  }

  @override
  Future<List<Protocol>> getAll() async => protocols.values.toList();

  @override
  Future<Protocol?> getById(String id) async => protocols[id];

  @override
  Future<Protocol?> getByName(String name) async {
    for (final protocol in protocols.values) {
      if (protocol.name == name) return protocol;
    }
    return null;
  }

  @override
  Future<void> save(Protocol protocol) async {
    protocols[protocol.id] = protocol;
    saveCalls.add(protocol);
  }
}
