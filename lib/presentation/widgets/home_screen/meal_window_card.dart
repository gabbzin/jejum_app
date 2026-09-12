import 'package:flutter/material.dart';
import 'package:jejum_app/presentation/providers/fasting_controller.dart';
import 'package:jejum_app/utils/format_time.dart';
import 'package:provider/provider.dart';

class MealWindowCard extends StatefulWidget {
  const new({super.key});

  @override
  State<MealWindowCard> createState() => _MealWindowCardState();
}

class _MealWindowCardState extends State<MealWindowCard> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FastingSessionController>();
    final theme = Theme.of(context);

    final eatingWindowStartEstimated = formatTime(
      controller.currentSession?.endTimeEstimated,
    );
    final eatingWindowEndEstimated = formatTime(
      controller.eatingWindowEndEstimated,
    );

    return Card(
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.restaurant,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8.0),
                Text(
                  "Janela de refeição",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),

            Text(
              textAlign: TextAlign.end,
              "$eatingWindowStartEstimated - $eatingWindowEndEstimated",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
