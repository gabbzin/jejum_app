import "package:flutter/material.dart";
import "package:jejum_app/presentation/providers/fasting_controller.dart";
import "package:jejum_app/presentation/widgets/protocol_name_card.dart";
import "package:jejum_app/utils/format_remaining_duration.dart";
import "package:provider/provider.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FastingSessionController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Image(
              image: AssetImage("public/images/logo_icone.png"),
              width: 40,
              height: 40,
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {
              // Navigate to the sick screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ProtocolNameCard(
              protocolName: controller.currentProtocolName,
              theme: theme,
            ),

            SizedBox(height: 20),

            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: controller.progress,
                    strokeWidth: 16,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                Column(
                  children: [
                    Text("TEMPO RESTANTE"),
                    Text(
                      formatRemainingDuration(controller.remainingDuration),
                      style: theme.textTheme.headlineLarge,
                    ),
                    Text("${(controller.progress * 100).toInt()}% concluído"),
                  ],
                ),
              ],
            ),

            IconButton(
              onPressed: () async {
                final controller = context.read<FastingSessionController>();
                await controller.startFasting('12_12');
              },
              icon: const Icon(Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }
}
