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

  Meal copyWith({String? name, int? calories, DateTime? time}) {
    return Meal(
      id: id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      time: time ?? this.time,
    );
  }
}
