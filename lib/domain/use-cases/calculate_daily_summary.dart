import 'package:jejum_app/domain/entities/fasting_session.dart';
import 'package:jejum_app/domain/repositories/fasting_session_repository.dart';
import 'package:jejum_app/domain/repositories/meal_repository.dart';

// DTO de Resposta
class DailySummary {
  final DateTime date;
  final int totalCalories;
  final Duration totalFastingTime;
  final bool metGoal;

  const DailySummary({
    required this.date,
    required this.totalCalories,
    required this.totalFastingTime,
    required this.metGoal,
  });
}

// Relatório diário de jejum e alimentação (UM DIA ESPECIFICO [ex: 01/01/2024])
class CalculateDailySummaryUseCase {
  final FastingSessionRepository _fastingSessionRepository;
  final MealRepository _mealRepository;

  CalculateDailySummaryUseCase({
    required this._fastingSessionRepository,
    required this._mealRepository,
  });

  Future<DailySummary> call(DateTime day) async {
    final rawSessions = await _fastingSessionRepository.getByDay(day);
    final sessions = rawSessions.whereType<FastingSession>().toList();
    final meals = await _mealRepository.getByDay(day);

    final startOfDay = DateTime(day.year, day.month, day.day, 0, 0, 0);
    final endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59, 999);

    var totalFastingTime = Duration.zero;

    for (final session in sessions) {
      if (session.status == FastingStatus.cancelled) continue;

      // Determina o fim efetivo considerando se está pausado ou rodando
      final DateTime sessionEnd;
      if (session.endTime != null) {
        sessionEnd = session.endTime!;
      } else if (session.status == FastingStatus.paused &&
          session.pausedAt != null) {
        sessionEnd = session.pausedAt!;
      } else {
        sessionEnd = DateTime.now();
      }

      // Delimita dentro das 24h do dia consultado
      final effectiveStart = session.startTime.isAfter(startOfDay)
          ? session.startTime
          : startOfDay;

      final effectiveEnd = sessionEnd.isBefore(endOfDay)
          ? sessionEnd
          : endOfDay;

      if (effectiveEnd.isAfter(effectiveStart)) {
        final duration = effectiveEnd.difference(effectiveStart);
        final paused = session.totalPausedDuration ?? Duration.zero;

        final netDuration = duration - paused;
        if (!netDuration.isNegative) {
          totalFastingTime += netDuration;
        }
      }
    }

    var totalCalories = 0;
    for (final meal in meals) {
      totalCalories += meal.calories;
    }

    // Avaliação da meta: se houver sessão, compara com o alvo da última sessão do dia
    final bool metGoal = sessions.isNotEmpty
        ? totalFastingTime >= sessions.last.targetDuration
        : false;

    return DailySummary(
      date: day,
      totalCalories: totalCalories,
      totalFastingTime: totalFastingTime,
      metGoal: metGoal,
    );
  }
}
