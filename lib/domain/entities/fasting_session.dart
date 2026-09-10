enum FastingStatus { active, paused, finished, cancelled }

// Serve para definir valores não nulos (undefined do TS)
class _Unset {
  const _Unset();
}

class FastingSession {
  final String id;
  final String protocolId;
  final DateTime startTime;
  final DateTime? endTime;
  final DateTime? pausedAt;
  final Duration? totalPausedDuration;
  final FastingStatus status;
  final Duration targetDuration;

  const FastingSession({
    required this.id,
    required this.protocolId,
    required this.startTime,
    this.endTime,
    this.pausedAt,
    this.totalPausedDuration = Duration.zero,
    required this.status,
    required this.targetDuration,
  });

  static const _unset = _Unset();

  Duration get elapsed => (endTime ?? DateTime.now()).difference(startTime);

  FastingSession copyWith({
    String? id,
    String? protocolId,
    DateTime? startTime,
    DateTime? endTime,
    Object? pausedAt = _unset,
    Duration? totalPausedDuration,
    Duration? targetDuration,
    FastingStatus? status,
  }) {
    return FastingSession(
      id: id ?? this.id,
      protocolId: protocolId ?? this.protocolId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      pausedAt: pausedAt is _Unset ? this.pausedAt : pausedAt as DateTime?,
      totalPausedDuration: totalPausedDuration ?? this.totalPausedDuration,
      targetDuration: targetDuration ?? this.targetDuration,
      status: status ?? this.status,
    );
  }

  bool get reachedGoal {
    final end = endTime ?? DateTime.now();
    final elapsed =
        end.difference(startTime) - (totalPausedDuration ?? Duration.zero);
    return elapsed >= targetDuration;
  }
}
