import 'package:flutter/material.dart';
import 'package:jejum_app/domain/entities/protocol.dart';
import 'package:jejum_app/domain/use-cases/protocol/mutations/delete_custom_protocol.dart';
import 'package:jejum_app/presentation/providers/fasting_controller.dart';
import 'package:jejum_app/presentation/widgets/dialogs/protocol_dialog.dart';
import 'package:provider/provider.dart';

class ProtocolCards extends StatelessWidget {
  final bool isFasting;
  final Future<List<Protocol>> _protocolosFuture;
  final VoidCallback? onChanged;

  const ProtocolCards({
    super.key,
    required this.isFasting,
    required this._protocolosFuture,
    this.onChanged,
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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (protocol.isCustom) ...[
                    IconButton(
                      tooltip: 'Editar',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: isFasting
                          ? null
                          : () async {
                              final edited = await showEditProtocolDialog(
                                context,
                                protocol,
                              );
                              if (!context.mounted) return;
                              if (edited == true) {
                                onChanged?.call();
                              }
                            },
                    ),
                    IconButton(
                      tooltip: 'Excluir',
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: isFasting
                          ? null
                          : () async {
                              final confirmed =
                                  await showDeleteProtocolConfirmation(
                                    context,
                                    protocol,
                                  );
                              if (confirmed != true) return;
                              if (!context.mounted) return;
                              try {
                                await context
                                    .read<DeleteCustomProtocolUseCase>()
                                    .call(protocol.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Protocolo "${protocol.name}" removido.',
                                      ),
                                    ),
                                  );
                                }
                                onChanged?.call();
                              } on ArgumentError catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.message.toString()),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Erro ao remover protocolo: $e',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                    ),
                  ],
                  ElevatedButton(
                    // Desativa o botão, caso tenha um jejum ativo
                    onPressed: isFasting
                        ? null
                        : () {
                            context
                                .read<FastingSessionController>()
                                .startFasting(protocol.id);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFasting
                          ? Colors.grey
                          : Theme.of(context).colorScheme.primary,
                    ),
                    child: const Text('Iniciar'),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
