import 'package:flutter/material.dart';

class ProtocolNameCard extends StatelessWidget {
  final String? protocolName;
  final ThemeData theme;

  const ProtocolNameCard({super.key, this.protocolName, required this.theme});

  Icon get circleIcon => protocolName != null
      ? Icon(Icons.circle, color: theme.colorScheme.primary)
      : Icon(Icons.circle, color: Colors.red);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            circleIcon,
            const SizedBox(width: 8.0),
            Text(protocolName ?? "Nenhum protocolo selecionado.", style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
