import 'package:flutter/material.dart';
import 'package:multi_shop_list/pages/home_page.dart';

void main() {
  runApp(const MultiShopListApp());
}

class MultiShopListApp extends StatelessWidget {
  const MultiShopListApp({super.key});

  // This widget is the root of your application.
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
