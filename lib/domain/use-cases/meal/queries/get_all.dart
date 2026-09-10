import 'package:jejum_app/domain/entities/meal.dart';
import 'package:jejum_app/domain/repositories/meal_repository.dart';

class GetAllMealsUseCase {
  final MealRepository mealRepository;

  GetAllMealsUseCase(this.mealRepository);

  Future<List<Meal>> call() {
    return mealRepository.getAll();
  }
}
