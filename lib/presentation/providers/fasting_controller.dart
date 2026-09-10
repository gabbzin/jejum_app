import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jejum_app/domain/entities/fasting_session.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/end_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/pause_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/resume_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/start_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/queries/get_actual.dart';

class FastingController extends ChangeNotifier {
  final GetActualFastingSessionUseCase _getActual;
  final StartFastingSessionUseCase _startSession;
  final PauseFastingSessionUseCase _pauseSession;
  final ResumeFastingSessionUseCase _resumeSession;
  final EndFastingSessionUseCase _endSession;

  FastingSession? currentSession;
  Timer? _ticker;
  bool isLoading = true;
  String? errorMessage;
  bool _isDisposed = false;

  FastingController(
    this._getActual,
    this._startSession,
    this._pauseSession,
    this._resumeSession,
    this._endSession,
  );

  bool get isFasting => currentSession != null;
  bool get isPaused => currentSession?.status == FastingStatus.paused;

  Duration get elapsedDuration =>
      currentSession != null ? currentSession!.elapsed : Duration.zero;

  Duration get remainingDuration {
    if (currentSession == null) return Duration.zero;
    final remaining = currentSession!.targetDuration - currentSession!.elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  double get progress {
    if (currentSession == null ||
        currentSession!.targetDuration.inSeconds == 0) {
      return 0;
    }
    final progress =
        elapsedDuration.inSeconds / currentSession!.targetDuration.inSeconds;
    return progress.clamp(0.0, 1.0);
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  Future<void> init() async {
    isLoading = true;
    notifyListeners();

    currentSession = await _getActual();

    if (currentSession != null &&
        currentSession!.status == FastingStatus.active) {
      _startTicker();
    }

    isLoading = false;
    notifyListeners();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      notifyListeners(); // Notifica os ouvintes a cada segundo para atualizar o tempo
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  // O tempo é definido lá no use case
  Future<void> startFasting(String protocolId) async {
    try {
      await _startSession(protocolId: protocolId);
      currentSession = await _getActual();

      if (currentSession != null &&
          currentSession!.status == FastingStatus.active) {
        _startTicker();
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> pauseFasting() async {
    if (currentSession == null) return;
    await _pauseSession();

    currentSession = await _getActual();

    _stopTicker();
    notifyListeners();
  }

  Future<void> resumeFasting() async {
    if (currentSession == null) return;
    await _resumeSession();

    currentSession = await _getActual();

    if (currentSession != null &&
        currentSession!.status == FastingStatus.active) {
      _startTicker();
    }

    notifyListeners();
  }

  Future<void> endFasting() async {
    if (currentSession == null) return;
    await _endSession();

    currentSession = null;

    _stopTicker();
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _stopTicker();
    super.dispose();
  }
}
