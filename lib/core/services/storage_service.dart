import 'package:hive_flutter/adapters.dart';
import 'package:jejum_app/data/models/fasting_session_model.dart';
import 'package:jejum_app/data/models/meal_model.dart';
import 'package:jejum_app/data/models/protocol_model.dart';

class StorageService {
  static const String fastingSessionBox = 'sessions';
  static const String mealBox = 'meals';
  static const String protocolBox = 'protocols';

  static late Box<FastingSessionModel> fastingSessionBoxInstance;
  static late Box<MealModel> mealBoxInstance;
  static late Box<ProtocolModel> protocolBoxInstance;

  static Future<void> init() async {
    await Hive.initFlutter();
  }

  static void registerAdapters(List<TypeAdapter<dynamic>> adapters) {
    for (var adapter in adapters) {
      if (!Hive.isAdapterRegistered(adapter.typeId)) {
        Hive.registerAdapter(adapter);
      }
    }
  }

  static Future<void> openBoxes() async {
    fastingSessionBoxInstance = await Hive.openBox<FastingSessionModel>(
      StorageService.fastingSessionBox,
    );
    mealBoxInstance = await Hive.openBox<MealModel>(StorageService.mealBox);
    protocolBoxInstance = await Hive.openBox<ProtocolModel>(
      StorageService.protocolBox,
    );
  }
}
