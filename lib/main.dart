import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fridge_filler/models/list_model.dart';
import 'package:fridge_filler/pages/home_page.dart';
import 'package:fridge_filler/provider/database_provider.dart';

void main() async {
  await Hive.initFlutter('hive_boxes');
  //Hive.openLazyBox<ListEntry>('box').then((box) => box.deleteFromDisk());
  Hive.registerAdapter(ListEntryAdapter());
  Hive.registerAdapter(ItemEntryAdapter());
  runApp(DatabaseProvider(child: const MultiShopListApp()));
}

class MultiShopListApp extends StatelessWidget {
  const MultiShopListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Shop List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
