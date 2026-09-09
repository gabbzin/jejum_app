import 'package:hive/hive.dart';

part 'meal_model.g.dart';

@HiveType(typeId: 2)
class MealModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int calories;

  @HiveField(3)
  DateTime dateTime;

  MealModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.dateTime,
  });
}
