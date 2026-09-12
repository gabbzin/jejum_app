import 'package:flutter/material.dart';
import 'package:jejum_app/presentation/screens/home_screen.dart';
import 'package:jejum_app/presentation/screens/meals_screen.dart';
import 'package:jejum_app/presentation/screens/protocol_screen.dart';
import 'package:jejum_app/presentation/widgets/dialogs/protocol_dialog.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  final _protocolScreenKey = GlobalKey<ProtocolScreenState>();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const MealsScreen(),
      ProtocolScreen(key: _protocolScreenKey),
    ];
  }

  Widget? _buildFab() {
    switch (_selectedIndex) {
      case 1: // Refeições
        return FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        );
      case 2: // Protocolos
        return FloatingActionButton(
          onPressed: () async {
            final created = await showAddProtocolDialog(context);
            if (created == true) {
              _protocolScreenKey.currentState?.refresh();
            }
          },
          child: const Icon(Icons.add),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Refeições',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Protocolos',
          ),
        ],
      ),

      floatingActionButton: _buildFab(),
    );
  }
}
