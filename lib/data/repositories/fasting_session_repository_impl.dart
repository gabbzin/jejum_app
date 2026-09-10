import "package:hive/hive.dart";
import "package:injectable/injectable.dart";
import "package:jejum_app/data/mappers/fasting_session_mapper.dart";
import "package:jejum_app/data/models/fasting_session_model.dart";

import "package:jejum_app/domain/repositories/fasting_session_repository.dart";
import "package:jejum_app/domain/entities/fasting_session.dart";
import 'package:collection/collection.dart';

@LazySingleton(as: FastingSessionRepository)
class FastingSessionRepositoryImpl implements FastingSessionRepository {
  final Box<FastingSessionModel> _box;

  FastingSessionRepositoryImpl(this._box);

  @override
  Future<List<FastingSession>> getAll() async {
    return _box.values.map(FastingSessionMapper.toEntity).toList();
  }

  @override
  Future<FastingSession?> getById(String id) async {
    final fastingSession = _box.get(id);
    return fastingSession != null
        ? FastingSessionMapper.toEntity(fastingSession)
        : null;
  }

  @override
  Future<FastingSession?> getByProtocolId(String protocolId) async {
    final fastingSession = _box.values.firstWhereOrNull(
      (element) => element.protocolId == protocolId,
    );
    return fastingSession != null
        ? FastingSessionMapper.toEntity(fastingSession)
        : null;
  }

  @override
  Future<FastingSession?> getActual() async {
    final actual = _box.values.firstWhereOrNull(
      // ignore: unrelated_type_equality_checks
      (element) => element.status == FastingStatus.active.name,
    );

    return actual != null ? FastingSessionMapper.toEntity(actual) : null;
  }

  @override
  Future<void> save(FastingSession fastingSession) async {
    final model = FastingSessionMapper.toModel(fastingSession);
    await _box.put(fastingSession.id, model);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
