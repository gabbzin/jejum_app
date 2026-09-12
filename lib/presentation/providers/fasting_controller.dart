import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jejum_app/core/services/notification_service.dart';
import 'package:jejum_app/domain/entities/fasting_session.dart';
import 'package:jejum_app/domain/entities/protocol.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/end_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/pause_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/resume_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/start_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/queries/get_actual.dart';
import 'package:jejum_app/domain/use-cases/protocol/queries/get_by_id.dart';

class FastingSessionController extends ChangeNotifier {
  final GetActualFastingSessionUseCase _getActual;
  final StartFastingSessionUseCase _startSession;
  final PauseFastingSessionUseCase _pauseSession;
  final ResumeFastingSessionUseCase _resumeSession;
  final EndFastingSessionUseCase _endSession;
  final GetProtocolByIdUseCase _getProtocolById;

  static const int _timerNotificationId = 100;

  FastingSession? currentSession;
  Protocol? currentProtocol;
  Timer? _ticker;
  bool isLoading = true;
  String? errorMessage;
  bool _isDisposed = false;

  FastingSessionController(
    this._getActual,
    this._startSession,
    this._pauseSession,
    this._resumeSession,
    this._endSession,
    this._getProtocolById,
  );

  bool get isFasting => currentSession != null;
  bool get isPaused => currentSession?.status == FastingStatus.paused;
  Duration get pausedDuration =>
      currentSession?.totalPausedDuration ?? Duration.zero;
  String? get currentProtocolName => currentProtocol?.name;

  DateTime? get eatingWindowEndEstimated {
    if (currentSession == null || currentProtocol == null) return null;
    return currentSession!.endTimeEstimated.add(
      Duration(hours: currentProtocol!.eatingHours),
    );
  }

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

  Future<void> _loadSessionAndProtocol() async {
    currentSession = await _getActual();
    if (currentSession != null) {
      currentProtocol = await _getProtocolById(currentSession!.protocolId);
    } else {
      currentProtocol = null;
    }
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

    await _loadSessionAndProtocol();

    if (currentSession != null &&
        currentSession!.status == FastingStatus.active) {
      _startTicker();
      // Restaura a notificação se o app foi reaberto enquanto o jejum estava ativo
      await _syncTimerNotification();
    }

    isLoading = false;
    notifyListeners();
  }

  // Notificação flutuante com base no tempo decorrido real
  Future<void> _syncTimerNotification() async {
    if (currentSession == null) return;

    final adjustedBaseTime = DateTime.now().subtract(currentSession!.elapsed);

    try {
      await NotificationService.showFastingTimerNotification(
        id: _timerNotificationId,
        title: "Jejum Ativo",
        body:
            "Tempo restante: ${remainingDuration.inHours}h ${remainingDuration.inMinutes.remainder(60)}m",
        startTime: adjustedBaseTime,
      );
    } catch (_) {
      // Ignora falhas de notificação em testes ou plataformas sem suporte
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Verifica se a meta de tempo já foi atingida
      if (remainingDuration == Duration.zero && currentSession != null) {
        NotificationService.showNotification(
          id: 101,
          title: "Parabéns!",
          body: "Você completou seu protocolo de jejum!",
        ).catchError((_) {});
      }
      notifyListeners();
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  Future<void> startFasting(String protocolId) async {
    try {
      errorMessage = null;
      await _startSession(protocolId: protocolId);
      await _loadSessionAndProtocol();

      if (currentSession != null &&
          currentSession!.status == FastingStatus.active) {
        await _syncTimerNotification();
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
    await _loadSessionAndProtocol();

    try {
      await NotificationService.stopTimerNotification(_timerNotificationId);
    } catch (_) {}
    _stopTicker();
    notifyListeners();
  }

  Future<void> resumeFasting() async {
    if (currentSession == null) return;
    await _resumeSession();
    await _loadSessionAndProtocol();

    if (currentSession != null &&
        currentSession!.status == FastingStatus.active) {
      await _syncTimerNotification();
      _startTicker();
    }

    notifyListeners();
  }

  Future<void> endFasting() async {
    if (currentSession == null) return;
    await _endSession();

    try {
      await NotificationService.stopTimerNotification(_timerNotificationId);
    } catch (_) {}
    currentSession = null;
    currentProtocol = null;

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
