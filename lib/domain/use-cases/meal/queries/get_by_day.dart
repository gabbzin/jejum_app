import 'package:jejum_app/domain/entities/meal.dart';
import 'package:jejum_app/domain/repositories/meal_repository.dart';

class GetByDayMealUseCase {
  final MealRepository _mealRepository;

  GetByDayMealUseCase(this._mealRepository);

  Future<List<Meal>> call(DateTime day) {
    return _mealRepository.getByDay(day);
  }
}
