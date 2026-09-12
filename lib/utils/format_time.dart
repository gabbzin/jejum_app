String formatTime(DateTime? dateTime) {
  if (dateTime == null) {
    return '';
  }
  return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
}
