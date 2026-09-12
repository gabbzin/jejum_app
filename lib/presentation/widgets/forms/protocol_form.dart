import 'package:flutter/material.dart';
import 'package:jejum_app/domain/entities/protocol.dart';
import 'package:jejum_app/domain/use-cases/protocol/mutations/create_custom_protocol.dart';
import 'package:jejum_app/domain/use-cases/protocol/mutations/edit_custom_protocol.dart';
import 'package:provider/provider.dart';

class ProtocolForm extends StatefulWidget {
  final String buttonText;
  final Protocol? protocolToEdit;

  const ProtocolForm({super.key, required this.buttonText, this.protocolToEdit});

  bool get isEditing => protocolToEdit != null;

  @override
  State<ProtocolForm> createState() => _ProtocolFormState();
}

class _ProtocolFormState extends State<ProtocolForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _fastingHours;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _name = widget.protocolToEdit?.name ?? '';
    _fastingHours = widget.protocolToEdit?.fastingHours ?? 16;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final createProtocol = context.read<CreateCustomProtocolUseCase>();
    final editProtocol = context.read<EditCustomProtocolUseCase>();

    Future<void> handleSubmit(String name, int fastingHours) async {
      final eatingHours = 24 - fastingHours;

      setState(() => _isSubmitting = true);
      try {
        if (widget.isEditing) {
          await editProtocol(
            protocolId: widget.protocolToEdit!.id,
            name: name,
            fastingHours: fastingHours,
            eatingHours: eatingHours,
          );
        } else {
          await createProtocol(
            name: name,
            fastingHours: fastingHours,
            eatingHours: eatingHours,
          );
        }
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
          SnackBar(
            content: Text(
              'Erro ao ${widget.isEditing ? 'editar' : 'criar'} protocolo: $e',
            ),
          ),
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
          Text(
            widget.isEditing ? "Editar Protocolo" : "Adicionar Protocolo",
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            widget.isEditing
                ? "Altere as informações do protocolo customizado."
                : "Não gostou de nenhum protocolo? Adicione um novo!",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _name,
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
            initialValue: _fastingHours.toString(),
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
