import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fridge_filler/models/list_model.dart';
import 'package:fridge_filler/pages/home_page.dart';
import 'package:fridge_filler/provider/database_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter('hive_boxes');
  //Hive.openLazyBox<ListEntry>('box').then((box) => box.deleteFromDisk());
  Hive.registerAdapter(ListEntryAdapter());
  Hive.registerAdapter(ItemEntryAdapter());
  var box = await Hive.openBox<ListEntry>('box');
  runApp(DatabaseProvider(box: box, child: const FridgeFillerApp()));
}

class FridgeFillerApp extends StatelessWidget {
  const FridgeFillerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fridge Filler',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('de', ''),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
