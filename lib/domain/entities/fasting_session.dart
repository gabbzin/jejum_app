enum FastingStatus { active, paused, finished }

class FastingSession {
  final String id;
  final String protocolId;
  final DateTime startTime;
  final DateTime? endTime;
  final FastingStatus status;

  const FastingSession({
    required this.id,
    required this.protocolId,
    required this.startTime,
    this.endTime,
    required this.status,
  });

  Duration get elapsed => (endTime ?? DateTime.now()).difference(startTime);

  FastingSession copyWith({
    String? id,
    String? protocolId,
    DateTime? startTime,
    DateTime? endTime,
    FastingStatus? status,
  }) {
    return FastingSession(
      id: id ?? this.id,
      protocolId: protocolId ?? this.protocolId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
    );
  }
}
