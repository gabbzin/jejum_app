import "package:hive/hive.dart";
import "package:injectable/injectable.dart";
import "package:jejum_app/data/mappers/meal_mapper.dart";
import "package:jejum_app/data/models/meal_model.dart";
import "package:jejum_app/domain/entities/meal.dart";

import 'package:jejum_app/domain/repositories/meal_repository.dart';

@LazySingleton(as: MealRepository)
class MealRepositoryImpl implements MealRepository {
  final Box<MealModel> _box;

  MealRepositoryImpl(this._box);

  @override
  Future<List<Meal>> getAll() async {
    return _box.values.map(MealMapper.toEntity).toList();
  }

  @override
  Future<Meal?> getById(String id) async {
    final meal = _box.get(id);
    return meal != null ? MealMapper.toEntity(meal) : null;
  }

  @override
  Future<void> save(Meal meal) async {
    final model = MealMapper.toModel(meal);
    return _box.put(meal.id, model);
  }

  @override
  Future<void> delete(String id) async {
    return _box.delete(id);
  }
}
