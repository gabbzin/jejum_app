// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
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
import 'package:jejum_app/presentation/widgets/home_screen/protocol_name_card.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('shows when no fasting protocol is selected', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: FastingSessionController(
            GetActualFastingSessionUseCase(FakeSessionRepository()),
            StartFastingSessionUseCase(
              FakeSessionRepository(),
              FakeProtocolRepository(),
            ),
            PauseFastingSessionUseCase(FakeSessionRepository()),
            ResumeFastingSessionUseCase(FakeSessionRepository()),
            EndFastingSessionUseCase(FakeSessionRepository()),
            GetProtocolByIdUseCase(FakeProtocolRepository()),
          ),
          child: const ProtocolNameCard(),
        ),
      ),
    );

    expect(find.text('Nenhum protocolo selecionado.'), findsOneWidget);
  });
}

class FakeSessionRepository implements FastingSessionRepository {
  @override
  Future<void> cancel(String id) async {}

  @override
  Future<void> delete(String id) async {}

  @override
  Future<List<FastingSession>> getAll() async => [];

  @override
  Future<List<FastingSession?>> getByDay(DateTime day) async => [];

  @override
  Future<List<FastingSession?>> getByProtocolId(String protocolId) async => [];

  @override
  Future<FastingSession?> getById(String id) async => null;

  @override
  Future<FastingSession?> getActual() async => null;

  @override
  Future<void> save(FastingSession fastingSession) async {}
}

class FakeProtocolRepository implements ProtocolRepository {
  @override
  Future<void> delete(String id) async {}

  @override
  Future<List<Protocol>> getAll() async => [];

  @override
  Future<Protocol?> getById(String id) async => null;

  @override
  Future<Protocol?> getByName(String name) async => null;

  @override
  Future<void> save(Protocol protocol) async {}
}
