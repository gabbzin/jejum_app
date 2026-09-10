import 'package:jejum_app/domain/entities/meal.dart';
import 'package:jejum_app/domain/repositories/meal_repository.dart';
import 'package:uuid/uuid.dart';

class AddMealUseCase {
  final MealRepository mealRepository;

  AddMealUseCase(this.mealRepository);

  Future<void> call({
    required String name,
    required int calories,
    DateTime? time,
  }) {
    if (calories < 0) {
      throw Exception('As calorias não podem ser negativas.');
    }

    if (calories > 10000) {
      throw Exception(
        'Esse valor parece muito alto. Por favor, verifique se está correto.',
      );
    }

    if (name.trim().isEmpty) {
      throw Exception('O nome da refeição não pode estar vazio.');
    }

    final meal = Meal(
      id: const Uuid().v4(),
      name: name,
      calories: calories,
      time: time ?? DateTime.now(),
    );

    return mealRepository.save(meal);
  }
}
