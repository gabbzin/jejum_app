import 'package:flutter/material.dart';
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
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/end_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/pause_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/resume_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/mutations/start_fasting.dart';
import 'package:jejum_app/domain/use-cases/fasting_session/queries/get_actual.dart';
import 'package:jejum_app/domain/use-cases/protocol/queries/get_by_id.dart';
import 'package:jejum_app/presentation/providers/fasting_controller.dart';
import 'package:jejum_app/presentation/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.init();

  StorageService.registerAdapters([
    FastingSessionModelAdapter(),
    FastingStatusAdapter(),
    MealModelAdapter(),
    ProtocolModelAdapter(),
  ]);

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

  final getProtocolById = GetProtocolByIdUseCase(protocolRepo);

  runApp(
    MultiProvider(
      providers: [
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
      home: const HomeScreen(),

      debugShowCheckedModeBanner: false,
      // routes: {'/': (context) => const HomeScreen()},
    );
  }
}
