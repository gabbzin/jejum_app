String formatPausedTime(Duration pausedDuration) {
  final hours = pausedDuration.inHours;
  final minutes = pausedDuration.inMinutes.remainder(60);

  if (hours > 0) {
    return "$hours h ${minutes.toString().padLeft(2, '0')} min";
  } else if (minutes > 0) {
    return "${minutes}min";
  }

  return '';
}
