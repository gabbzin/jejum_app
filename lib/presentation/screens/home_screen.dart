import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:jejum_app/presentation/providers/fasting_controller.dart";
import "package:jejum_app/presentation/widgets/home_screen/actions_button_timer.dart";
import "package:jejum_app/presentation/widgets/home_screen/infos_fasting_card.dart";
import "package:jejum_app/presentation/widgets/home_screen/meal_window_card.dart";
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

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        spacing: 24,
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

          MealWindowCard(),
        ],
      ),
    );
  }
}
