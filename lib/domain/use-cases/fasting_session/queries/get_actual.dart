import 'package:jejum_app/data/repositories/fasting_session_repository_impl.dart';
import 'package:jejum_app/domain/entities/fasting_session.dart';

class GetActualFastingSessionUseCase {
  final FastingSessionRepositoryImpl _repository;

  GetActualFastingSessionUseCase(this._repository);

  Future<FastingSession?> call() {
    return _repository.getActual();
  }
}
