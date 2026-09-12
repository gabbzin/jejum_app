import 'package:flutter/material.dart';
import 'package:jejum_app/domain/entities/protocol.dart';
import 'package:jejum_app/presentation/providers/fasting_controller.dart';
import 'package:provider/provider.dart';

class ProtocolCards extends StatelessWidget {
  final bool isFasting;
  final Future<List<Protocol>> _protocolosFuture;

  const ProtocolCards({
    super.key,
    required this.isFasting,
    required this._protocolosFuture,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _protocolosFuture,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (asyncSnapshot.hasError) {
          return Text('Erro ao carregar protocolos: ${asyncSnapshot.error}');
        }

        final protocolos = asyncSnapshot.data ?? [];

        return Column(
          children: protocolos.map((protocol) {
            return ListTile(
              title: Text(
                "${protocol.isCustom ? '' : 'Protocolo'} ${protocol.name}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${protocol.fastingHours}h jejum / ${protocol.eatingHours}h alimentação',
              ),
              trailing: ElevatedButton(
                // Desativa o botão, caso tenha um jejum ativo
                onPressed: isFasting
                    ? null
                    : () {
                        context.read<FastingSessionController>().startFasting(
                          protocol.id,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFasting
                      ? Colors.grey
                      : Theme.of(context).colorScheme.primary,
                ),
                child: const Text('Iniciar'),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
