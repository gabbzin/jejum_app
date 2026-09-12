import 'package:flutter/material.dart';
import 'package:jejum_app/core/services/notification_service.dart';
import 'package:jejum_app/core/services/storage_service.dart';
import 'package:jejum_app/core/theme/app_theme.dart';
import 'package:jejum_app/data/models/fasting_session_model.dart';
import 'package:jejum_app/data/models/fasting_status_adapter.dart';
import 'package:jejum_app/data/models/meal_model.dart';
import 'package:jejum_app/data/models/protocol_model.dart';
import 'package:jejum_app/data/repositories/fasting_session_repository_impl.dart';
import 'package:jejum_app/data/repositories/meal_repository_impl.dart';
import 'package:jejum_app/data/repositories/protocol_repository_impl.dart';
import 'package:jejum_app/data/seeds/protocol_seed.dart';
import 'package:jejum_app/domain/entities/fasting_session.dart';
import 'package:jejum_app/domain/use-cases/calculate_daily_summary.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/cancel_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/delete_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/end_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/pause_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/resume_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/start_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/queries/get_actual.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/queries/get_all.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/queries/get_by_id.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/queries/get_by_protocol_id.dart';
import 'package:jejum_app/domain/use-cases/meal/mutations/add_meal.dart';
import 'package:jejum_app/domain/use-cases/meal/mutations/delete_meal.dart';
import 'package:jejum_app/domain/use-cases/meal/mutations/edit_meal.dart';
import 'package:jejum_app/domain/use-cases/meal/queries/get_all.dart';
import 'package:jejum_app/domain/use-cases/meal/queries/get_by_day.dart';
import 'package:jejum_app/domain/use-cases/protocol/mutations/create_custom_protocol.dart';
import 'package:jejum_app/domain/use-cases/protocol/mutations/delete_custom_protocol.dart';
import 'package:jejum_app/domain/use-cases/protocol/queries/get_all.dart';
import 'package:jejum_app/domain/use-cases/protocol/queries/get_by_id.dart';
import 'package:jejum_app/presentation/layout/root_screen.dart';
import 'package:jejum_app/presentation/providers/fasting_controller.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();
  await StorageService.init();

  StorageService.registerAdapter<FastingSessionModel>(
    FastingSessionModelAdapter(),
  );
  StorageService.registerAdapter<FastingStatus>(FastingStatusAdapter());
  StorageService.registerAdapter<MealModel>(MealModelAdapter());
  StorageService.registerAdapter<ProtocolModel>(ProtocolModelAdapter());

  await StorageService.openBoxes();

  final fastingSessionRepo = FastingSessionRepositoryImpl(
    StorageService.fastingSessionBoxInstance,
  );
  final mealRepo = MealRepositoryImpl(StorageService.mealBoxInstance);
  final protocolRepo = ProtocolRepositoryImpl(
    StorageService.protocolBoxInstance,
  );
  await ProtocolSeed.seed(protocolRepo);

  final getActual = GetActualFastingSessionUseCase(fastingSessionRepo);
  final startSession = StartFastingSessionUseCase(
    fastingSessionRepo,
    protocolRepo,
  );
  final endSession = EndFastingSessionUseCase(fastingSessionRepo);
  final pauseSession = PauseFastingSessionUseCase(fastingSessionRepo);
  final resumeSession = ResumeFastingSessionUseCase(fastingSessionRepo);

  final cancelSession = CancelSessionUseCase(fastingSessionRepo);
  final deleteFastingSession = DeleteFastingSessionUseCase(fastingSessionRepo);
  final getAllFastingSessions = GetAllFastingSessionsUseCase(
    fastingSessionRepo,
  );
  final getFastingSessionById = GetByIdFastingSessionsUseCase(
    fastingSessionRepo,
  );
  final getFastingSessionsByProtocol = GetByProtocolIdFastingSessionsUseCase(
    fastingSessionRepo,
  );

  final addMeal = AddMealUseCase(mealRepo);
  final deleteMeal = DeleteMealUseCase(mealRepo);
  final editMeal = EditMealUseCase(mealRepo);
  final getAllMeals = GetAllMealsUseCase(mealRepo);
  final getMealsByDay = GetByDayMealUseCase(mealRepo);

  final createCustomProtocol = CreateCustomProtocolUseCase(protocolRepo);
  final deleteCustomProtocol = DeleteCustomProtocolUseCase(protocolRepo);
  final getAllProtocols = GetAllProtocolUseCase(protocolRepo);
  final getProtocolById = GetProtocolByIdUseCase(protocolRepo);

  final calculateDailySummary = CalculateDailySummaryUseCase(
    fastingSessionRepository: fastingSessionRepo,
    mealRepository: mealRepo,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: getActual),
        Provider.value(value: startSession),
        Provider.value(value: pauseSession),
        Provider.value(value: resumeSession),
        Provider.value(value: endSession),
        Provider.value(value: cancelSession),
        Provider.value(value: deleteFastingSession),
        Provider.value(value: getAllFastingSessions),
        Provider.value(value: getFastingSessionById),
        Provider.value(value: getFastingSessionsByProtocol),
        Provider.value(value: addMeal),
        Provider.value(value: deleteMeal),
        Provider.value(value: editMeal),
        Provider.value(value: getAllMeals),
        Provider.value(value: getMealsByDay),
        Provider.value(value: createCustomProtocol),
        Provider.value(value: deleteCustomProtocol),
        Provider.value(value: getAllProtocols),
        Provider.value(value: getProtocolById),
        Provider.value(value: calculateDailySummary),
        ChangeNotifierProvider(
          create: (_) => FastingSessionController(
            getActual,
            startSession,
            pauseSession,
            resumeSession,
            endSession,
            getProtocolById,
          )..init(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jejum+',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const RootScreen(),

      debugShowCheckedModeBanner: false,
    );
  }
}
