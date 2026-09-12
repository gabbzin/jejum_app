import 'package:flutter/material.dart';
import 'package:jejum_app/domain/entities/protocol.dart';
import 'package:jejum_app/presentation/widgets/forms/protocol_form.dart';

Future<bool?> showAddProtocolDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ProtocolForm(buttonText: "Cadastrar Protocolo"),
        ),
      );
    },
  );
}

Future<bool?> showEditProtocolDialog(
  BuildContext context,
  Protocol protocol,
) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ProtocolForm(
            buttonText: "Salvar Alterações",
            protocolToEdit: protocol,
          ),
        ),
      );
    },
  );
}

Future<bool?> showDeleteProtocolConfirmation(
  BuildContext context,
  Protocol protocol,
) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Remover protocolo'),
        content: Text(
          'Deseja realmente remover o protocolo "${protocol.name}"? Essa ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remover'),
          ),
        ],
      );
    },
  );
}
