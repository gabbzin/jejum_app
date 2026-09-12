import 'package:flutter/material.dart';
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
