import 'package:jejum_app/domain/entities/meal.dart';
import 'package:jejum_app/domain/repositories/meal_repository.dart';

class EditMealUseCase {
  final MealRepository mealRepository;

  EditMealUseCase(this.mealRepository);

  Future<void> call(
    Meal existingMeal, {
    String? name,
    int? calories,
    DateTime? time,
  }) async {
    if (calories != null || name != null || time != null) {
      throw Exception(
        'Sem dados enviados para atualizar a refeição. Vai atualizar pra que?',
      );
    }

    if (calories != null) {
      if (calories < 0) {
        throw Exception('As calorias não podem ser negativas.');
      }

      if (calories > 10000) {
        throw Exception('As calorias não podem ser maiores que 10.000.');
      }
    }

    if (name != null && name.trim().isEmpty) {
      throw Exception('O nome da refeição não pode estar vazio.');
    }

    if (time != null && time.isAfter(DateTime.now())) {
      throw Exception('A hora da refeição não pode ser no futuro.');
    }

    final updated = existingMeal.copyWith(
      name: name,
      calories: calories,
      time: time,
    );
    await mealRepository.save(updated);
  }
}
