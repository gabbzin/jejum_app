import 'package:flutter/material.dart';
import 'package:jejum_app/domain/entities/protocol.dart';
import 'package:jejum_app/domain/use-cases/protocol/queries/get_all.dart';
import 'package:jejum_app/presentation/providers/fasting_controller.dart';
import 'package:jejum_app/presentation/widgets/protocol_screen/protocols.dart';
import 'package:provider/provider.dart';

class ProtocolScreen extends StatefulWidget {
  const ProtocolScreen({super.key});

  @override
  State<ProtocolScreen> createState() => ProtocolScreenState();
}

class ProtocolScreenState extends State<ProtocolScreen> {
  late Future<List<Protocol>> _protocolosFuture;

  @override
  void initState() {
    super.initState();
    _protocolosFuture = context.read<GetAllProtocolUseCase>()();
  }

  void refresh() {
    setState(() {
      _protocolosFuture = context.read<GetAllProtocolUseCase>()();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<FastingSessionController>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Protocolos Disponíveis',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.start,
          ),

          ProtocolCards(
            isFasting: controller.isFasting,
            protocolosFuture: _protocolosFuture,
          ),
        ],
      ),
    );
  }
}
