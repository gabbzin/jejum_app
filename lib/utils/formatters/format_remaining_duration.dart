String formatRemainingDuration(Duration remainingDuration) {
  final hours = remainingDuration.inHours.toString().padLeft(2, '0');
  final minutes = (remainingDuration.inMinutes % 60).toString().padLeft(2, '0');
  final seconds = (remainingDuration.inSeconds % 60).toString().padLeft(2, '0');

  return "$hours:$minutes:$seconds";
}
