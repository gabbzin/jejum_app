import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:jejum_app/presentation/providers/fasting_controller.dart";
import "package:jejum_app/presentation/widgets/home_screen/actions_button_timer.dart";
import "package:jejum_app/presentation/widgets/home_screen/infos_fasting_card.dart";
import "package:jejum_app/presentation/widgets/home_screen/protocol_name_card.dart";
import "package:jejum_app/presentation/widgets/home_screen/timer.dart";
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

    final elapsedDuration = controller.elapsedDuration;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Image(
              image: AssetImage("assets/images/logo_icone.png"),
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
          spacing: 32,
          children: [
            ProtocolNameCard(),

            Text(
              "Em jejum há ${elapsedDuration.inHours}h e ${elapsedDuration.inMinutes % 60}min",
              style: TextStyle(
                fontSize: 20,
                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            Timer(),

            ActionsButtonTimer(),

            InfosFastingCard(),
          ],
        ),
      ),
    );
  }
}
