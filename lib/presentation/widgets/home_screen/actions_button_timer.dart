import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jejum_app/presentation/providers/fasting_controller.dart';
import 'package:provider/provider.dart';

class ActionsButtonTimer extends StatefulWidget {
  const ActionsButtonTimer({super.key});

  @override
  State<ActionsButtonTimer> createState() => _ActionsButtonTimerState();
}

class _ActionsButtonTimerState extends State<ActionsButtonTimer> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FastingSessionController>();
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      spacing: 8,
      children: [
        // Botão para pausar e retomar o jejum
        ActionButtonTimer(
          color: controller.isFasting
              ? theme.colorScheme.primary
              : theme.colorScheme.secondary,
          label: controller.isFasting ? "Pausar" : "Retomar",
          icon: controller.isFasting ? Icons.pause : Icons.play_arrow,
          onPressed: () {
            if (controller.isFasting) {
              controller.pauseFasting();
            } else {
              controller.resumeFasting();
            }
          },
        ),

        // Botão para encerrar o jejum
        ActionButtonTimer(
          color: Colors.red,
          label: "Encerrar",
          icon: Icons.stop_circle_outlined,
          onPressed: () {
            controller.endFasting();
          },
        ),
      ],
    );
  }
}

class ActionButtonTimer extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const ActionButtonTimer({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(color),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Icon(icon, size: 20),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
