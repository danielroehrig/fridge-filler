// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fridge_filler/main.dart';
import 'package:fridge_filler/models/list_model.dart';
import 'package:fridge_filler/provider/database_provider.dart';
import 'package:hive/hive.dart';

class FakeBox<T> extends Fake implements Box<T> {
  Set<T> initialValues;
  @override
  Iterable<T> get values {
    return initialValues;
  }

  FakeBox(this.initialValues);
}

void main() {
  testWidgets('Tapping a list opens List', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(DatabaseProvider(
      box: FakeBox<ListEntry>(
          {ListEntry(name: "First List"), ListEntry(name: "Second List")}),
      child: const FridgeFillerApp(),
    ));

    expect(find.text('Fridge Filler'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text("First List"), findsOneWidget);
    expect(find.text("Second List"), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
  });
}
