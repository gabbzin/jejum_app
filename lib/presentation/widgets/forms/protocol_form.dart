import 'package:flutter/material.dart';
import 'package:jejum_app/domain/use-cases/protocol/mutations/create_custom_protocol.dart';
import 'package:provider/provider.dart';

class ProtocolForm extends StatefulWidget {
  final String buttonText;

  const ProtocolForm({super.key, required this.buttonText});

  @override
  State<ProtocolForm> createState() => _ProtocolFormState();
}

class _ProtocolFormState extends State<ProtocolForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _fastingHours = 0;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final createProtocol = context.read<CreateCustomProtocolUseCase>();

    Future<void> handleSubmit(String name, int fastingHours) async {
      final eatingHours = 24 - fastingHours;

      setState(() => _isSubmitting = true);
      try {
        await createProtocol(
          name: name,
          fastingHours: fastingHours,
          eatingHours: eatingHours,
        );
        if (!context.mounted) return;
        Navigator.of(context).pop(true);
      } on ArgumentError catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message.toString())),
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar protocolo: $e')),
        );
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Adicionar Protocolo", style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          Text(
            "Não gostou de nenhum protocolo? Adicione um novo!",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Nome do Protocolo'),
            autofocus: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor, insira um nome';
              }
              return null;
            },
            onSaved: (value) {
              _name = value!.trim();
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Horas de jejum'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira um valor entre 1 e 23';
              }
              final hours = int.tryParse(value);
              if (hours == null || hours < 1 || hours > 23) {
                return 'Por favor, insira um valor entre 1 e 23';
              }
              return null;
            },
            onSaved: (value) {
              _fastingHours = int.parse(value!);
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isSubmitting
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      handleSubmit(_name, _fastingHours);
                    }
                  },
            child: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.buttonText),
          ),
        ],
      ),
    );
  }
}
