import 'package:jejum_app/domain/entities/meal.dart';

abstract class IMealRepository {
  Future<List<Meal>> getAll();

  Future<Meal?> getById(String id);

  // Método para salvar (criação ou edição) de uma refeição
  Future<void> save(Meal meal);

  Future<void> delete(String id);
}
