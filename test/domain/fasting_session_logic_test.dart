import 'package:flutter_test/flutter_test.dart';
import 'package:jejum_app/domain/entities/fasting_session.dart';
import 'package:jejum_app/domain/entities/protocol.dart';
import 'package:jejum_app/domain/repositories/fasting_session_repository.dart';
import 'package:jejum_app/domain/repositories/protocol_repository.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/end_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/pause_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/resume_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/start_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/queries/get_actual.dart';
import 'package:jejum_app/domain/use-cases/protocol/queries/get_by_id.dart';
import 'package:jejum_app/presentation/providers/fasting_controller.dart';

void main() {
  final protocol = const Protocol(
    id: '16_8',
    name: '16:8',
    fastingHours: 16,
    eatingHours: 8,
  );

  test('restores the current session and protocol on initialization', () async {
    final session = FastingSession(
      id: 'session',
      protocolId: protocol.id,
      startTime: DateTime.now(),
      status: FastingStatus.active,
      targetDuration: const Duration(hours: 16),
    );
    final sessionRepository = InMemoryFastingSessionRepository(session);
    final protocolRepository = InMemoryProtocolRepository(protocol);
    final controller = FastingSessionController(
      GetActualFastingSessionUseCase(sessionRepository),
      StartFastingSessionUseCase(sessionRepository, protocolRepository),
      PauseFastingSessionUseCase(sessionRepository),
      ResumeFastingSessionUseCase(sessionRepository),
      EndFastingSessionUseCase(sessionRepository),
      GetProtocolByIdUseCase(protocolRepository),
    );

    await controller.init();

    expect(controller.currentSession?.id, session.id);
    expect(controller.currentProtocol?.id, protocol.id);
    controller.dispose();
  });

  test('elapsed time excludes a current pause', () {
    final session = FastingSession(
      id: 'session',
      protocolId: protocol.id,
      startTime: DateTime.now().subtract(const Duration(minutes: 10)),
      pausedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      status: FastingStatus.paused,
      targetDuration: const Duration(hours: 16),
    );

    expect(session.elapsed.inSeconds, inInclusiveRange(299, 301));
  });

  test('resume adds the current pause to the total pause duration', () async {
    final session = FastingSession(
      id: 'session',
      protocolId: protocol.id,
      startTime: DateTime.now().subtract(const Duration(minutes: 10)),
      pausedAt: DateTime.now().subtract(const Duration(minutes: 2)),
      totalPausedDuration: const Duration(minutes: 1),
      status: FastingStatus.paused,
      targetDuration: const Duration(hours: 16),
    );
    final repository = InMemoryFastingSessionRepository(session);

    await ResumeFastingSessionUseCase(repository).call();

    expect(repository.savedSession!.status, FastingStatus.active);
    expect(
      repository.savedSession!.totalPausedDuration!.inSeconds,
      greaterThanOrEqualTo(179),
    );
  });

  test('ending a paused session includes its current pause', () async {
    final session = FastingSession(
      id: 'session',
      protocolId: protocol.id,
      startTime: DateTime.now().subtract(const Duration(minutes: 10)),
      pausedAt: DateTime.now().subtract(const Duration(minutes: 2)),
      totalPausedDuration: const Duration(minutes: 1),
      status: FastingStatus.paused,
      targetDuration: const Duration(hours: 16),
    );
    final repository = InMemoryFastingSessionRepository(session);

    await EndFastingSessionUseCase(repository).call();

    expect(repository.savedSession!.status, FastingStatus.finished);
    expect(repository.savedSession!.pausedAt, isNull);
    expect(
      repository.savedSession!.totalPausedDuration!.inSeconds,
      greaterThanOrEqualTo(179),
    );
  });

  test('rejects an unknown protocol when starting a session', () async {
    final repository = InMemoryFastingSessionRepository();
    final protocolRepository = InMemoryProtocolRepository(protocol);

    expect(
      () => StartFastingSessionUseCase(
        repository,
        protocolRepository,
      ).call(protocolId: 'unknown'),
      throwsArgumentError,
    );
    expect(repository.savedSession, isNull);
  });
}

class InMemoryFastingSessionRepository implements FastingSessionRepository {
  InMemoryFastingSessionRepository([FastingSession? session]) {
    if (session != null) sessions[session.id] = session;
  }

  final Map<String, FastingSession> sessions = {};
  FastingSession? savedSession;

  @override
  Future<void> cancel(String id) async {}

  @override
  Future<void> delete(String id) async => sessions.remove(id);

  @override
  Future<List<FastingSession>> getAll() async => sessions.values.toList();

  @override
  Future<List<FastingSession?>> getByDay(DateTime day) async => [];

  @override
  Future<List<FastingSession?>> getByProtocolId(String protocolId) async => [];

  @override
  Future<FastingSession?> getById(String id) async => sessions[id];

  @override
  Future<FastingSession?> getActual() async {
    for (final session in sessions.values) {
      if (session.status == FastingStatus.active ||
          session.status == FastingStatus.paused) {
        return session;
      }
    }
    return null;
  }

  @override
  Future<void> save(FastingSession fastingSession) async {
    savedSession = fastingSession;
    sessions[fastingSession.id] = fastingSession;
  }
}

class InMemoryProtocolRepository implements ProtocolRepository {
  InMemoryProtocolRepository(this.protocol);

  final Protocol protocol;

  @override
  Future<void> delete(String id) async {}

  @override
  Future<List<Protocol>> getAll() async => [protocol];

  @override
  Future<Protocol?> getById(String id) async =>
      id == protocol.id ? protocol : null;

  @override
  Future<Protocol?> getByName(String name) async =>
      name == protocol.name ? protocol : null;

  @override
  Future<void> save(Protocol protocol) async {}
}
