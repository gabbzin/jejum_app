import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jejum_app/presentation/providers/fasting_controller.dart';
import 'package:jejum_app/utils/formatters/format_remaining_duration.dart';
import 'package:provider/provider.dart';

class Timer extends StatelessWidget {
  const Timer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<FastingSessionController>();
    final remainingDuration = controller.remainingDuration;
    final progress = controller.progress;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 250,
          height: 250,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 24,
            backgroundColor: theme.colorScheme.surfaceContainer,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  controller.isFasting ? Icons.timer : Icons.pause,
                  size: 24,
                  color: theme.colorScheme.primary,
                ),
                Text(
                  controller.isFasting ? "TEMPO RESTANTE" : "PAUSADO",
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ],
            ),

            Text(
              formatRemainingDuration(remainingDuration),
              style: TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w800,
                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                color: theme.colorScheme.primary,
              ),
            ),

            Text(
              "${(progress * 100).toInt()}% concluído",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
