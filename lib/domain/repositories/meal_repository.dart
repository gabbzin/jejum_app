import 'package:jejum_app/domain/entities/meal.dart';

abstract class MealRepository {
  Future<List<Meal>> getAll();

  Future<List<Meal>> getByDay(DateTime day);

  // Método para salvar (criação ou edição) de uma refeição
  Future<void> save(Meal meal);

  Future<void> delete(String id);
}
