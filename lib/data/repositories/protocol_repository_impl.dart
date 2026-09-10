import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:jejum_app/data/mappers/protocol_mapper.dart';
import 'package:jejum_app/data/models/protocol_model.dart';
import 'package:jejum_app/domain/entities/protocol.dart';
import 'package:jejum_app/domain/repositories/protocol_repository.dart';

@LazySingleton(as: ProtocolRepository)
class ProtocolRepositoryImpl implements ProtocolRepository {
  final Box<ProtocolModel> _box;

  ProtocolRepositoryImpl(this._box);

  @override
  Future<List<Protocol>> getAll() async {
    return _box.values.map(ProtocolMapper.toEntity).toList();
  }

  @override
  Future<Protocol?> getById(String id) async {
    final protocol = _box.get(id);
    return protocol != null ? ProtocolMapper.toEntity(protocol) : null;
  }

  @override
  Future<Protocol?> getByName(String name) async {
    final protocol = _box.values.firstWhereOrNull(
      (element) => element.name == name,
    );
    return protocol != null ? ProtocolMapper.toEntity(protocol) : null;
  }

  @override
  Future<void> save(Protocol protocol) async {
    final model = ProtocolMapper.toModel(protocol);
    await _box.put(protocol.id, model);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
