import 'package:jejum_app/data/models/meal_model.dart';
import 'package:jejum_app/domain/entities/meal.dart';

class MealMapper {
  static Meal toEntity(MealModel model) {
    return Meal(
      id: model.id,
      name: model.name,
      calories: model.calories,
      time: model.dateTime,
    );
  }

  static MealModel toModel(Meal entity) {
    return MealModel(
      id: entity.id,
      name: entity.name,
      calories: entity.calories,
      dateTime: entity.time,
    );
  }
}
