import 'package:jejum_app/domain/entities/protocol.dart';

abstract class IProtocolRepository {
  Future<List<Protocol>> getAll();

  Future<Protocol?> getById(String id);

  Future<Protocol?> getByName(String name);

  Future<void> delete(String id);

  // Método para salvar (criação ou edição) de um protocolo
  Future<void> save(Protocol protocol);
}
