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
    var firstList = ListEntry(name: "First List");
    firstList.entries.add(ItemEntry(name: "First item first list"));
    var secondList = ListEntry(name: "Second List");
    secondList.entries.add(ItemEntry(name: "First item second list"));
    await tester.pumpWidget(DatabaseProvider(
      box: FakeBox<ListEntry>({firstList, secondList}),
      child: const FridgeFillerApp(),
    ));

    expect(find.text('Fridge Filler'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text("First List"), findsOneWidget);
    expect(find.text("Second List"), findsOneWidget);
    expect(find.text("First item first list"), findsNothing);

    await tester.tap(find.text('First List'));
    await tester.pumpAndSettle();
    expect(find.text("Second List"), findsNothing);
    expect(find.text("First List"), findsOneWidget);
    expect(find.text("First item first list"), findsOneWidget);
  });
}
