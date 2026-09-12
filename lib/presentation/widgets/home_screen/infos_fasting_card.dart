import 'package:flutter/material.dart';
import 'package:jejum_app/presentation/providers/fasting_controller.dart';
import 'package:jejum_app/utils/formatters/format_paused_time.dart';
import 'package:jejum_app/utils/formatters/format_remaining_duration.dart';
import 'package:provider/provider.dart';

class InfosFastingCard extends StatelessWidget {
  const InfosFastingCard({super.key});

  String formatDateTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FastingSessionController>();
    final currentSession = controller.currentSession;

    if (currentSession == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text("Sem sessão ativa no momento."),
        ),
      );
    }

    final fastingStartTime = currentSession.startTime;
    final fastingEndTimeEstimated = currentSession.endTimeEstimated;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 4,
      children: [
        Expanded(
          child: InfoCard(
            icon: Icons.sunny,
            title: "Início",
            value: formatDateTime(fastingStartTime),
          ),
        ),
        Expanded(
          child: InfoCard(
            icon: Icons.flag,
            title: "Meta final",
            value: formatDateTime(fastingEndTimeEstimated),
          ),
        ),
        Expanded(
          child: InfoCard(
            icon: Icons.info,
            title: "Pausa",
            value: formatPausedTime(controller.pausedDuration),
          ),
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final EdgeInsets padding = const EdgeInsets.all(12.0);

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: padding,
        child: Column(
          spacing: 4,
          children: [
            Row(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icon, size: 16, color: theme.colorScheme.primary),
                Text(title),
              ],
            ),

            Text(
              value,
              style: TextStyle(
                fontSize: theme.textTheme.titleLarge?.fontSize,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
