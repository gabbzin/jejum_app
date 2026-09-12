import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jejum_app/presentation/providers/fasting_controller.dart';
import 'package:provider/provider.dart';

class ActionsButtonTimer extends StatelessWidget {
  const ActionsButtonTimer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FastingSessionController>();
    final theme = Theme.of(context);

    if (!controller.isFasting) {
      return Text(
        "Sem sessão ativa, inicie uma na janela de protocolos.",
        style: TextStyle(
          fontSize: 16,
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      spacing: 8,
      children: [
        // Botão para pausar e retomar o jejum
        ActionButtonTimer(
          color: !controller.isPaused
              ? theme.colorScheme.primary
              : theme.colorScheme.secondary,
          label: !controller.isPaused ? "Pausar" : "Retomar",
          icon: !controller.isPaused ? Icons.pause : Icons.play_arrow,
          onPressed: () {
            if (!controller.isPaused) {
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
          onPressed: () async {
            final bool? confirmation = await showDialog<bool>(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  title: const Text("Encerrar Jejum"),
                  content: const Text(
                    "Tem certeza que deseja encerrar o jejum?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(false);
                      },
                      child: const Text("Cancelar"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(true);
                      },
                      child: const Text("Encerrar"),
                    ),
                  ],
                );
              },
            );

            if (confirmation == true && context.mounted) {
              context.read<FastingSessionController>().endFasting();
            }
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
