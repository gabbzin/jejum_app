class Meal {
  final String id;
  final String name;
  final int calories;
  final DateTime time;

  Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.time,
  });

  DateTime get day => DateTime(time.year, time.month, time.day);
}
