import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'jejum_app_channel_v1';
  static const String _channelName = 'Lembretes de Jejum';
  static const String _channelDesc =
      'Notificações importantes sobre o status do jejum';

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    // Cria explicitamente o canal com importância máxima
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await androidImplementation?.createNotificationChannel(channel);

    // Solicita permissão para Android 13+ (API 33+)
    await androidImplementation?.requestNotificationsPermission();
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          playSound: true,
          enableVibration: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(id, title, body, platformChannelSpecifics);
  }

  static Future<void> showFastingTimerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime startTime, // Horário exato que o jejum começou
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'jejum_timer_channel',
          'Timer de Jejum Ativo',
          channelDescription: 'Exibe o tempo decorrido do jejum em tempo real',
          importance: Importance.high, // evita apitar/vibrar a cada atualização
          priority: Priority.high,
          ongoing: true, // Fixa a notificação na barra
          autoCancel: false, // Cancela automaticamente
          when: startTime.millisecondsSinceEpoch, // Base de cálculo do relógio
          showWhen: true,
          category: AndroidNotificationCategory.workout,
          styleInformation: MediaStyleInformation(
            htmlFormatTitle: true,
            htmlFormatContent: true,
          ),
        );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(id, title, body, platformChannelSpecifics);
  }

  static Future<void> stopTimerNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}
