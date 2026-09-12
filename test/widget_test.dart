// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jejum_app/presentation/widgets/protocol_name_card.dart';

void main() {
  testWidgets('shows when no fasting protocol is selected', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: ProtocolNameCard(theme: ThemeData())),
    );

    expect(find.text('Nenhum protocolo selecionado.'), findsOneWidget);
  });
}
