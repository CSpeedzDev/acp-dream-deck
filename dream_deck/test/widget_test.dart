// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:dream_deck/main.dart';

// Basic test placeholder for DreamDeck app

void main() {
  testWidgets('DreamDeck app loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DreamDeckApp());

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify that our app loaded successfully
    expect(find.text('DreamDeck'), findsOneWidget);
  });
}
