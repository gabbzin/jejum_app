import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:jejum_app/data/models/fasting_session_model.dart';
import 'package:jejum_app/data/models/fasting_status_adapter.dart';
import 'package:jejum_app/data/repositories/fasting_session_repository_impl.dart';
import 'package:jejum_app/domain/entities/fasting_session.dart';

void main() {
  late Directory tempDirectory;
  late Box<FastingSessionModel> box;
  late FastingSessionRepositoryImpl repository;

  setUpAll(() async {
    tempDirectory = await Directory.systemTemp.createTemp('jejum_app_test_');
    Hive.init(tempDirectory.path);
    Hive.registerAdapter(FastingStatusAdapter());
    Hive.registerAdapter(FastingSessionModelAdapter());
    box = await Hive.openBox<FastingSessionModel>('fasting_sessions');
    repository = FastingSessionRepositoryImpl(box);
  });

  tearDown(() async {
    await box.clear();
  });

  tearDownAll(() async {
    await box.close();
    await tempDirectory.delete(recursive: true);
  });

  test('returns a paused session as the current session', () async {
    await box.put(
      'paused',
      FastingSessionModel(
        id: 'paused',
        protocolId: '16_8',
        startTime: DateTime.now().subtract(const Duration(hours: 1)),
        pausedAt: DateTime.now(),
        status: FastingStatus.paused,
        targetDuration: const Duration(hours: 16).inMilliseconds,
      ),
    );

    final actual = await repository.getActual();

    expect(actual?.id, 'paused');
    expect(actual?.status, FastingStatus.paused);
  });
}
