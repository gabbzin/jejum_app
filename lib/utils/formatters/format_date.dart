String formatDate(DateTime date, bool includeReference) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();
  String acrescimo = "";

  if (includeReference) {
    final now = DateTime.now();
    final finalDate = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);

    if (finalDate.isAtSameMomentAs(today)) {
      acrescimo = 'Hoje,';
    } else if (finalDate.isAtSameMomentAs(today.subtract(Duration(days: 1)))) {
      acrescimo = 'Ontem,';
    } else if (finalDate.isAtSameMomentAs(today.add(Duration(days: 1)))) {
      acrescimo = 'Amanhã,';
    }
  }

  return '$acrescimo $day/$month/$year';
}
