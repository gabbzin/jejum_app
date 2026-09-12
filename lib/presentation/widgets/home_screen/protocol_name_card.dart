import 'package:flutter/material.dart';
import 'package:jejum_app/presentation/providers/fasting_controller.dart';
import 'package:provider/provider.dart';

class ProtocolNameCard extends StatelessWidget {
  const ProtocolNameCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FastingSessionController>();
    final protocolName = controller.currentProtocolName;
    final protocolText = protocolName != null
        ? 'Protocolo ativo: $protocolName'
        : null;

    final theme = Theme.of(context);
    Icon circleIcon = protocolName != null
        ? Icon(Icons.circle, color: theme.colorScheme.primary)
        : Icon(Icons.circle, color: Colors.red);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            circleIcon,
            const SizedBox(width: 8.0),
            Text(
              protocolText ?? "Nenhum protocolo selecionado.",
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
