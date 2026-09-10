import 'package:jejum_app/domain/repositories/meal_repository.dart';

class DeleteMealUseCase {
  final MealRepository _mealRepository;

  DeleteMealUseCase(this._mealRepository);

  Future<void> call(String mealId) async {
    await _mealRepository.delete(mealId);
  }
}
